import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/auth/auth_controller.dart';
import '../../../common/auth/service/user_service.dart';
import '../../../core/data/local/secure_storage/secure_storage_provider.dart';
import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../../core/data/remote/token/token_const.dart';
import '../data/dto/login_request.dart';
import '../service/login_service.dart';
import '../state/login_state.dart';

final loginControllerProvider =
    AutoDisposeNotifierProvider<LoginController, LoginState>(
      () => LoginController(),
    );

class LoginController extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() {
    return LoginState();
  }

  Future<void> login() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final loginRequest = LoginRequest(
        email: state.loginData['email'] ?? '',
        password: state.loginData['password'] ?? '',
      );

      final result = await ref.read(loginServiceProvider).login(loginRequest);

      // save token to local storage
      await ref
          .read(secureStorageProvider)
          .write(key: accessTokenKey, value: result.accessToken);
      await ref
          .read(secureStorageProvider)
          .write(key: refreshTokenKey, value: result.refreshToken);

      // fetch user profile
      final userService = ref.read(userServiceProvider);
      final user = await userService.fetchUserProfile();

      // set authenticated state
      await ref.read(authControllerProvider.notifier).setAuthenticated(user);
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await ref.read(loginServiceProvider).loginWithGoogle();

      // save token to local storage
      await ref
          .read(secureStorageProvider)
          .write(key: accessTokenKey, value: result.accessToken);
      await ref
          .read(secureStorageProvider)
          .write(key: refreshTokenKey, value: result.refreshToken);

      // fetch user profile
      final userService = ref.read(userServiceProvider);
      final user = await userService.fetchUserProfile();

      // set authenticated state
      await ref.read(authControllerProvider.notifier).setAuthenticated(user);
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
    } catch (e) {
      print(e.toString());
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateLoginData(final String email, final String password) {
    state = state.copyWith(loginData: {'email': email, 'password': password});
  }
}
