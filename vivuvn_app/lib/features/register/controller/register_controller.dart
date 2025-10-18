import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../data/dto/register_request.dart';
import '../data/dto/verify_email_request.dart';
import '../service/register_service.dart';
import '../state/register_state.dart';

final registerControllerProvider =
    AutoDisposeNotifierProvider<RegisterController, RegisterState>(
      () => RegisterController(),
    );

class RegisterController extends AutoDisposeNotifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  Future<void> register() async {
    state = state.copyWith(isLoading: true, error: null);

    final req = RegisterRequest(
      email: state.registerData['email'] ?? '',
      username: state.registerData['username'] ?? '',
      password: state.registerData['password'] ?? '',
    );

    try {
      await ref.read(registerServiceProvider).register(req);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'unknown error', isLoading: false);
    }
  }

  Future<void> verifyEmail(final String verificationCode) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final verificationRequest = VerifyEmailRequest(
        email: state.registerData['email'] ?? '',
        token: verificationCode,
      );
      await ref.read(registerServiceProvider).verifyEmail(verificationRequest);
      state = state.copyWith(
        isLoading: false,
        isEmailVerified: true,
        error: null,
      );
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Verification failed', isLoading: false);
    }
  }

  /// Cập nhật tất cả trường cùng lúc
  void updateRegisterData(
    final String email,
    final String username,
    final String password,
  ) {
    state = state.copyWith(
      registerData: {
        'email': email,
        'username': username,
        'password': password,
      },
    );
  }

  /// Cập nhật từng trường riêng lẻ
  void updateRegisterField({
    final String? email,
    final String? username,
    final String? password,
  }) {
    state = state.copyWith(
      registerData: {
        'email': email ?? state.registerData['email'] ?? '',
        'username': username ?? state.registerData['username'] ?? '',
        'password': password ?? state.registerData['password'] ?? '',
      },
    );
  }
}
