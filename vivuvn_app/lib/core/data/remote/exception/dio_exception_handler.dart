import 'package:dio/dio.dart';

class DioExceptionHandler {
  // Handle Dio Exceptions
  static String handleException(final DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with API server';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in connection with API server';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with API server';
      case DioExceptionType.badResponse:
        return _handleResponse(e.response);
      case DioExceptionType.cancel:
        return 'Request to API server was cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error with API server';
      case DioExceptionType.badCertificate:
        return 'Bad certificate from API server';
      case DioExceptionType.unknown:
        return 'Unexpected error occurred';
    }
  }

  static String _handleResponse(final Response? response) {
    if (response == null) {
      return 'No response from server';
    }

    switch (response.statusCode) {
      case 400:
        return response.data['detail'] ?? 'Bad request';
      case 401:
        return 'Unauthorized request';
      case 403:
        return 'Forbidden request';
      case 404:
        return 'Request not found';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      case 504:
        return 'Gateway timeout';
      default:
        return 'Error ${response.statusCode}: ${response.statusMessage}';
    }
  }
}
