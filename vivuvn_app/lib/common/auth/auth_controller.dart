import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/remote/network/network_service.dart';
import '../../core/data/remote/token/token_service.dart';
import 'auth_state.dart';

class AuthController extends AutoDisposeNotifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> checkAuthStatus() async {
    try {
      state = state.copyWith(isLoading: true);
      // Call your API or perform your authentication check here
      final dioInstance = ref.read(networkServiceProvider);
      final tokenService = ref.read(tokenServiceProvider(dioInstance));

      // get refresh token from secure storage
      final refreshToken = await tokenService.getRefreshToken();

      if (refreshToken.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          status: AuthStatus.unauthenticated,
        );
        return;
      }

      final refreshTokenResponse = await tokenService.refreshAccessToken();

      // save new token if success
      await tokenService.storeTokens(
        accessToken: refreshTokenResponse.accessToken,
        refreshToken: refreshTokenResponse.refreshToken,
      );

      // If successful, update the state accordingly
      state = state.copyWith(
        status: AuthStatus.authenticated,
        isLoading: false,
      );
    } on DioException catch (_) {
      state = state.copyWith(
        isLoading: false,
        status: AuthStatus.unauthenticated,
      );
    }
  }

  void setAuthenticated() {
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  Future<void> logout() async {
    final dioInstance = ref.read(networkServiceProvider);
    final tokenService = ref.read(tokenServiceProvider(dioInstance));
    await tokenService.clearTokens();
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider =
    AutoDisposeNotifierProvider<AuthController, AuthState>(
      () => AuthController(),
    );
