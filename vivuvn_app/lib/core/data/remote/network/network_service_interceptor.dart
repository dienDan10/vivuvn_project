import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/auth/controller/auth_controller.dart';
import '../../../../common/auth/dtos/refresh_token_response.dart';
import '../../../../common/http_status_code/http_status_code.dart';
import '../token/itoken_service.dart';
import '../token/token_service.dart';

final networkServiceInterceptorProvider =
    Provider.family<NetworkServiceInterceptor, Dio>((final ref, final dio) {
      final tokenService = ref.watch(tokenServiceProvider(dio));
      return NetworkServiceInterceptor(tokenService, dio, ref);
    });

class NetworkServiceInterceptor extends Interceptor {
  final ITokenService _tokenService;
  final Dio _dio;
  final Ref<NetworkServiceInterceptor> _ref;

  // Token refresh lock to prevent multiple simultaneous refresh requests
  bool _isRefreshing = false;
  final List<void Function()> _requestsQueue = [];

  NetworkServiceInterceptor(this._tokenService, this._dio, this._ref);

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

    // If already refreshing, queue this request
    if (_isRefreshing) {
      await _addRequestToQueue(err, handler);
      return;
    }

    // Set the refreshing flag
    _isRefreshing = true;

    // fetch new access token with refresh token
    try {
      // fetch a new access token
      final RefreshTokenResponse response = await _tokenService
          .refreshAccessToken();

      final newAccessToken = response.accessToken;
      final newRefreshToken = response.refreshToken;

      await _tokenService.storeTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // Retry the original request
      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final newResponse = await _dio.fetch(requestOptions);

      // Token refresh successful, process queued requests
      _isRefreshing = false;
      _processQueue();

      return handler.resolve(newResponse);
    } on DioException catch (e) {
      // Reset the flag on error
      _isRefreshing = false;

      // if the refresh token request fails
      if (e.requestOptions.path == '/api/v1/auth/refresh-token' &&
          e.response?.statusCode == badRequest) {
        // Handle refresh token errors
        await _tokenService.clearTokens();

        // Clear the queue since we're logging out
        _requestsQueue.clear();

        // set application state to logged out
        _ref.read(authControllerProvider.notifier).logout();

        return handler.next(err);
      }
      // if the retry of original request fails
      return handler.next(err);
    }
  }

  /// Add a failed request to the queue to be retried after token refresh
  Future<void> _addRequestToQueue(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    // Wait until refreshing is complete
    while (_isRefreshing) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // After refresh is complete, retry the request with new token
    try {
      final requestOptions = err.requestOptions;
      final newAccessToken = await _tokenService.getAccessToken();
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await _dio.fetch(requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  /// Process all queued requests (currently not needed as we handle in _addRequestToQueue)
  void _processQueue() {
    for (final callback in _requestsQueue) {
      callback();
    }
    _requestsQueue.clear();
  }
}
