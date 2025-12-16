import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';

/// API client cho upload ảnh bill/hóa đơn của budget item.
final expenseBillApiProvider = Provider.autoDispose<ExpenseBillApi>(
  (final ref) {
    final dio = ref.watch(networkServiceProvider);
    return ExpenseBillApi(dio);
  },
);

class ExpenseBillApi {
  final Dio dio;

  const ExpenseBillApi(this.dio);

  /// Upload 1 hoặc nhiều ảnh bill cho một budget item.
  ///
  /// Endpoint backend: `POST /api/v1/itineraries/{itineraryId}/budget/items/photo`.
  ///
  /// Backend action hiện tại: UploadBudgetItemImage([FromForm] UploadBudgetItemBillImageRequestDto request)
  /// → property file phía server tên là `BillPhoto`, nên client phải gửi đúng key này.
  ///
  /// - `itineraryId`: id lịch trình hiện tại (từ route).
  /// - `budgetItemId`: id của budget item vừa tạo/cập nhật (từ form field).
  /// - `filePaths`: danh sách path ảnh local (từ image picker). Backend hiện chỉ nhận 1 file,
  ///   nên client sẽ gửi file đầu tiên trong danh sách.
  ///
  /// Returns: imageUrl được Firebase trả về (hoặc null nếu không parse được).
  Future<String?> uploadBillsForBudgetItem({
    required final int itineraryId,
    required final int budgetItemId,
    required final List<String> filePaths,
  }) async {
    if (filePaths.isEmpty) return null;

    // Backend hiện tại chỉ nhận 1 file BillPhoto, nên chọn file đầu tiên.
    final String firstPath = filePaths.first;

    // Làm tương tự như upload avatar ở module profile:
    // chỉ cần dùng MultipartFile.fromFile, để Dio tự suy đoán content-type.
    final multipartFile = await MultipartFile.fromFile(firstPath);

    final formData = FormData.fromMap({
      'budgetItemId': budgetItemId,
      // Tên field phải trùng với property trong UploadBudgetItemBillImageRequestDto
      'BillPhoto': multipartFile,
    });

    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/itineraries/$itineraryId/budget/items/photo',
      data: formData,
    );

    final data = response.data;
    if (data == null) return null;

    final dynamic url = data['imageUrl'] ?? data['ImageUrl'];
    return url?.toString();
  }
}

