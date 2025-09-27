import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/dtos/refresh_token_response.dart';
import '../../../../common/http_status_code/http_status_code.dart';
import '../token/itoken_service.dart';
import '../token/token_service.dart';

final networkServiceInterceptorProvider =
    Provider.family<NetworkServiceInterceptor, Dio>((final ref, final dio) {
      final tokenService = ref.watch(tokenServiceProvider(dio));
      return NetworkServiceInterceptor(tokenService, dio);
    });

class NetworkServiceInterceptor extends Interceptor {
  final ITokenService _tokenService;
  final Dio _dio;

  NetworkServiceInterceptor(this._tokenService, this._dio);

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    options.headers['Authorization'] =
        'Bearer ${await _tokenService.getAccessToken()}';

    handler.next(options);
  }

  @override
  void onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != unauthorized) {
      return handler.next(err);
    }

    // if this is a accessToken expired error

    // fetch new access token with refresh token
    try {
      // fetch a new access token
      final RefreshTokenResponse response = await _tokenService
          .refreshAccessToken();

      final newAccessToken = response.data.accessToken;
      final newRefreshToken = response.data.refreshToken;

      await _tokenService.storeTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      final requestOptions = err.requestOptions;
      // update request header with new access token
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      // retry the original request with new access token
      final newResponse = await _dio.fetch(requestOptions);
      return handler.resolve(newResponse);
    } on DioException catch (e) {
      // if the refresh token request fails
      if (e.response?.statusCode == refreshTokenExpired &&
          e.requestOptions.path == '/api/v1/auth/refresh-token') {
        // Handle refresh token errors
        await _tokenService.clearTokens();
        // set error status code
        //err.response?.statusCode = refreshTokenExpired;

        // redirect user to login page

        return handler.next(err);
      }
      // if the retry of original request fails
      return handler.next(err);
    }
  }
}
