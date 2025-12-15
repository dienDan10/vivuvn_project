import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';

/// API client cho upload ảnh bill/hóa đơn của budget item.
///
/// Hiện tại chỉ được tạo sẵn để chờ tích hợp,
/// chưa có endpoint cụ thể và chưa được gọi từ controller.
final expenseBillApiProvider = Provider.autoDispose<ExpenseBillApi>(
  (final ref) {
    final dio = ref.watch(networkServiceProvider);
    return ExpenseBillApi(dio);
  },
);

class ExpenseBillApi {
  final Dio dio;

  const ExpenseBillApi(this.dio);

  /// Placeholder method để upload ảnh bill cho một budget item.
  ///
  /// TODO: Cập nhật path và body theo API backend khi có.
  Future<void> uploadBillsForBudgetItem({
    required final int itineraryId,
    required final int budgetItemId,
    required final List<String> filePaths,
  }) async {
    // Giữ method trống để tránh gọi nhầm khi backend chưa sẵn sàng,
    // nhưng vẫn tham chiếu tới `dio` để tránh cảnh báo linter.
    // ignore: unused_local_variable
    final Dio _ = dio;
    // Ví dụ upload multipart (comment lại để tránh gọi nhầm):
    //
    // final formData = FormData.fromMap({
    //   'files': await Future.wait(
    //     filePaths.map(
    //       (path) async => await MultipartFile.fromFile(path),
    //     ),
    //   ),
    // });
    //
    // await _dio.post(
    //   '/api/v1/itineraries/$itineraryId/budget/items/$budgetItemId/bills',
    //   data: formData,
    // );
  }
}


