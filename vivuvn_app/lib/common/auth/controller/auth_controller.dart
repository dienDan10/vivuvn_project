import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/remote/network/network_service.dart';
import '../../../core/data/remote/token/token_service.dart';
import '../../../features/itinerary/view-itinerary-list/models/user.dart';
import '../../../features/notification/service/notification_service.dart';
import '../service/user_service.dart';
import '../state/auth_state.dart';

class AuthController extends Notifier<AuthState> {
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

      // fetch user profile
      final userService = ref.read(userServiceProvider);
      final user = await userService.fetchUserProfile();

      // If successful, update the state accordingly
      await setAuthenticated(user);
    } on DioException catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setAuthenticated(final User user) async {
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
    final service = ref.read(notificationServiceProvider);
    await service.registerDevice();
  }

  Future<void> logout() async {
    final dioInstance = ref.read(networkServiceProvider);
    final tokenService = ref.read(tokenServiceProvider(dioInstance));
    await tokenService.clearTokens();
    state = state.copyWith(status: AuthStatus.unauthenticated);
    final service = ref.read(notificationServiceProvider);
    await service.deactivateDevice();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  () => AuthController(),
);
