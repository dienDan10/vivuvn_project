import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/toast/global_toast.dart';
import '../state/expense_bill_state.dart';

final expenseBillControllerProvider =
    StateNotifierProvider.autoDispose<ExpenseBillController, ExpenseBillState>(
  (final ref) => ExpenseBillController(),
);

/// Controller quản lý state ảnh bill/hóa đơn cho form chi phí.
///
/// - Chọn ảnh từ gallery
/// - Xoá ảnh đã chọn
/// - Reset danh sách ảnh
/// API upload sẽ được tích hợp sau (hiện chỉ quản lý local paths).
class ExpenseBillController extends StateNotifier<ExpenseBillState> {
  ExpenseBillController() : super(const ExpenseBillState());

  void _setPicking(final bool value) {
    state = state.copyWith(isPicking: value, error: null);
  }

  void _setError(final String message) {
    state = state.copyWith(error: message);
  }

  void _setSavingToGallery(final bool value) {
    state = state.copyWith(isSavingToGallery: value);
  }

  /// Chọn nhiều ảnh bill từ gallery và thêm vào danh sách hiện tại.
  Future<void> pickBillsFromGallery(final BuildContext context) async {
    try {
      _setPicking(true);
      final picker = ImagePicker();

      // Chỉ cho phép chọn 1 ảnh để tránh spam preview.
      final file = await picker.pickImage(source: ImageSource.gallery);

      if (file == null) {
        _setPicking(false);
        return;
      }

      state = state.copyWith(
        // Ghi đè danh sách, chỉ giữ một ảnh.
        localImagePaths: [file.path],
        isPicking: false,
        error: null,
      );
    } catch (e) {
      _setPicking(false);
      _setError(e.toString());
    }
  }

  /// Xóa một ảnh bill theo index.
  void removeBillAt(final int index) {
    if (index < 0 || index >= state.localImagePaths.length) return;
    final updated = List<String>.from(state.localImagePaths)..removeAt(index);
    state = state.copyWith(localImagePaths: updated, error: null);
  }

  /// Clear toàn bộ ảnh bill trong form hiện tại.
  void clearBills() {
    state = const ExpenseBillState();
  }

  /// Lưu ảnh bill hiện tại về thư viện (gallery).
  Future<void> savePreviewToGallery(
    final BuildContext context,
    final String path,
  ) async {
    _setSavingToGallery(true);
    try {
      final isNetwork = path.startsWith('http');

      if (!await Gal.hasAccess()) {
        await Gal.requestAccess();
      }
      if (!await Gal.hasAccess()) {
        if (context.mounted) {
          GlobalToast.showErrorToast(
            context,
            message: 'Không có quyền lưu vào thư viện',
          );
        }
        return;
      }

      final bytes = await _readBytes(path, isNetwork: isNetwork);
      if (bytes == null) {
        if (context.mounted) {
          GlobalToast.showErrorToast(
            context,
            message: 'Không đọc được dữ liệu ảnh',
          );
        }
        return;
      }

      final fileName =
          'vivuvn_bill_${DateTime.now().millisecondsSinceEpoch}.png';

      await Gal.putImageBytes(bytes, name: fileName);

      if (context.mounted) {
        GlobalToast.showSuccessToast(
          context,
          message: 'Đã lưu ảnh vào thư viện',
        );
      }
    } catch (e) {
      if (context.mounted) {
        GlobalToast.showErrorToast(
          context,
          message: _mapSaveError(e),
        );
      }
    } finally {
      _setSavingToGallery(false);
    }
  }

  String _mapSaveError(final Object error) {
    if (error is GalException) {
      return 'Lưu ảnh thất bại: ${error.toString()}';
    }
    return 'Lưu ảnh thất bại';
  }

  Future<Uint8List?> _readBytes(
    final String path, {
    required final bool isNetwork,
  }) async {
    if (!isNetwork) {
      final file = File(path);
      final exists = await file.exists();
      if (!exists) return null;
      final bytes = await file.readAsBytes();
      return Uint8List.fromList(bytes);
    }

    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(path));
      final response = await request.close();
      if (response.statusCode != 200) return null;
      final bytes = await response.fold<List<int>>([], (final prev, final element) {
        prev.addAll(element);
        return prev;
      });
      client.close(force: true);
      return Uint8List.fromList(bytes);
    } catch (_) {
      return null;
    }
  }
}


