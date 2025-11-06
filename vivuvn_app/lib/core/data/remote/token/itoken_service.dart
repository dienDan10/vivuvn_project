import '../../../../common/auth/dtos/refresh_token_response.dart';

abstract interface class ITokenService {
  Future<String> getRefreshToken();
  Future<String> getAccessToken();
  Future<void> storeTokens({
    required final String accessToken,
    required final String refreshToken,
  });
  Future<void> clearTokens();
  Future<RefreshTokenResponse> refreshAccessToken();
}
