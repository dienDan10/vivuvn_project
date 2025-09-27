import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/dtos/refresh_token_response.dart';
import '../../local/secure_storage/isecure_storage.dart';
import '../../local/secure_storage/secure_storage_provider.dart';
import 'itoken_service.dart';
import 'token_const.dart';

final tokenServiceProvider = Provider.family<ITokenService, Dio>((
  final ref,
  final dio,
) {
  final secureStorage = ref.watch(secureStorageProvider);
  return TokenService(secureStorage, dio);
});

class TokenService implements ITokenService {
  final ISecureStorage _secureStorage;
  final Dio _dio;

  TokenService(this._secureStorage, this._dio);

  @override
  Future<String> getAccessToken() async {
    return await _secureStorage.read(key: accessTokenKey) ?? '';
  }

  @override
  Future<String> getRefreshToken() async {
    return await _secureStorage.read(key: refreshTokenKey) ?? '';
  }

  @override
  Future<void> storeTokens({
    required final String accessToken,
    required final String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(key: accessTokenKey, value: accessToken),
      _secureStorage.write(key: refreshTokenKey, value: refreshToken),
    ]);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: accessTokenKey),
      _secureStorage.delete(key: refreshTokenKey),
    ]);
  }

  @override
  Future<RefreshTokenResponse> refreshAccessToken() async {
    final String refreshToken = await getRefreshToken();
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/auth/refresh-token',
      data: {'refreshToken': refreshToken},
      options: Options(
        headers: {
          'Authorization': null,
        }, // refresh token don't need auth header
      ),
    );
    return RefreshTokenResponse.fromMap(response.data ?? {});
  }
}
