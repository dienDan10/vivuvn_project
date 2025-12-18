import 'package:dio/dio.dart';

class DioExceptionHandler {
  // Handle Dio Exceptions
  static String handleException(final DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Hết thời gian chờ kết nối đến máy chủ API';
      case DioExceptionType.sendTimeout:
        return 'Hết thời gian chờ gửi dữ liệu đến máy chủ API';
      case DioExceptionType.receiveTimeout:
        return 'Hết thời gian chờ nhận dữ liệu từ máy chủ API';
      case DioExceptionType.badResponse:
        return _handleResponse(e.response);
      case DioExceptionType.cancel:
        return 'Yêu cầu đến máy chủ API đã bị hủy';
      case DioExceptionType.connectionError:
        return 'Lỗi kết nối với máy chủ API';
      case DioExceptionType.badCertificate:
        return 'Chứng chỉ từ máy chủ API không hợp lệ';
      case DioExceptionType.unknown:
        return 'Lỗi không xác định';
    }
  }

  static String _handleResponse(final Response? response) {
    if (response == null) {
      return 'Không có phản hồi từ máy chủ';
    }

    switch (response.statusCode) {
      case 400:
        return response.data['detail'] ?? 'Yêu cầu không hợp lệ';
      case 401:
        return 'Yêu cầu không được phép';
      case 403:
        return 'Yêu cầu bị cấm';
      case 404:
        return 'Không tìm thấy yêu cầu';
      case 500:
        return 'Lỗi máy chủ nội bộ';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Dịch vụ không khả dụng';
      case 504:
        return 'Hết thời gian chờ cổng';
      default:
        return 'Lỗi ${response.statusCode}: ${response.statusMessage}';
    }
  }
}
