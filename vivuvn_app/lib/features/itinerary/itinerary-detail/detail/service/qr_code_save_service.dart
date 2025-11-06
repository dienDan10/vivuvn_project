import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../common/toast/global_toast.dart';

final qrCodeSaveServiceProvider =
    Provider.autoDispose<QrCodeSaveService>((final ref) {
  return QrCodeSaveService();
});

class QrCodeSaveService {
  /// Kiểm tra và yêu cầu quyền lưu trữ trên Android
  Future<bool> requestAndroidStoragePermission(
    final BuildContext context,
  ) async {
    if (!Platform.isAndroid) {
      return true; // Không cần kiểm tra trên nền tảng khác
    }

    try {
      // Android 13+ sử dụng READ_MEDIA_IMAGES, Android cũ hơn dùng storage
      const Permission permission = Permission.photos;

      final status = await permission.status;

      if (!status.isGranted) {
        final result = await permission.request();

        if (!result.isGranted) {
          if (!context.mounted) return false;
          GlobalToast.showErrorToast(
            context,
            message: 'Cần quyền truy cập bộ nhớ để lưu ảnh',
          );
          return false;
        }
      }
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      GlobalToast.showErrorToast(
        context,
        message: 'Không thể xin quyền truy cập bộ nhớ',
      );
      return false;
    }
  }

  /// Kiểm tra và yêu cầu quyền truy cập Gallery
  Future<bool> requestGalleryAccessPermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false; // Không hỗ trợ nền tảng khác
    }

    try {
      final hasAccess = await Gal.hasAccess();

      if (!hasAccess) {
        await Gal.requestAccess();
        final hasAccessAfter = await Gal.hasAccess();

        if (!hasAccessAfter) {
          return false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Kiểm tra nền tảng có được hỗ trợ không
  bool isPlatformSupported() {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Capture widget thành image bytes
  Future<Uint8List?> captureWidgetToImage(
    final GlobalKey repaintBoundaryKey,
    final BuildContext context,
  ) async {
    // Đợi widget được render và paint xong
    // Đợi frame hiện tại kết thúc
    await SchedulerBinding.instance.endOfFrame;

    // Đợi thêm một chút để đảm bảo widget được paint
    await Future.delayed(const Duration(milliseconds: 100));

    // Đợi frame tiếp theo để chắc chắn widget đã được paint
    await SchedulerBinding.instance.endOfFrame;

    // Lấy RenderRepaintBoundary từ GlobalKey
    final boundaryContext = repaintBoundaryKey.currentContext;

    if (boundaryContext == null) {
      if (!context.mounted) return null;
      GlobalToast.showErrorToast(
        context,
        message: 'Không thể capture QR code',
      );
      return null;
    }

    if (!context.mounted) return null;
    final RenderObject? renderObject = boundaryContext.findRenderObject();

    final RenderRepaintBoundary? boundary =
        renderObject is RenderRepaintBoundary ? renderObject : null;

    if (boundary == null) {
      if (!context.mounted) return null;
      GlobalToast.showErrorToast(
        context,
        message: 'Không thể capture QR code',
      );
      return null;
    }

    // Kiểm tra xem widget đã được paint chưa
    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 300));
      await SchedulerBinding.instance.endOfFrame;
    }

    // Capture widget thành image
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    if (byteData == null) {
      if (!context.mounted) return null;
      GlobalToast.showErrorToast(
        context,
        message: 'Không thể chuyển đổi QR code thành ảnh',
      );
      return null;
    }

    return byteData.buffer.asUint8List();
  }

  /// Lưu image bytes vào Gallery
  Future<bool> saveToGallery(
    final Uint8List pngBytes,
    final BuildContext context,
  ) async {
    try {
      // Yêu cầu quyền truy cập Gallery
      final hasGalleryAccess = await requestGalleryAccessPermission();
      if (!hasGalleryAccess) {
        throw Exception('Không có quyền truy cập Gallery');
      }

      // Tạo tên file
      final String fileName =
          'vivuvn_qrcode_${DateTime.now().millisecondsSinceEpoch}.png';

      // Lưu vào Gallery sử dụng gal package
      await Gal.putImageBytes(
        pngBytes,
        name: fileName,
      );

      if (!context.mounted) return true;
      GlobalToast.showSuccessToast(
        context,
        message: 'Đã lưu QR code vào Gallery thành công!',
        title: 'Thành công',
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// Lưu QR code từ widget vào Gallery
  Future<void> saveQrCodeToGallery(
    final BuildContext context,
    final GlobalKey repaintBoundaryKey,
  ) async {
    // Kiểm tra nền tảng có được hỗ trợ không
    if (!isPlatformSupported()) {
      if (!context.mounted) return;
      GlobalToast.showErrorToast(
        context,
        message: 'Nền tảng không được hỗ trợ',
      );
      return;
    }

    // Kiểm tra và yêu cầu quyền lưu trữ (chỉ trên Android)
    final hasStoragePermission = await requestAndroidStoragePermission(context);
    if (!hasStoragePermission) {
      return;
    }

    if (!context.mounted) return;

    // Capture widget thành image
    final pngBytes = await captureWidgetToImage(repaintBoundaryKey, context);
    if (pngBytes == null || !context.mounted) {
      return;
    }

    // Lưu vào Gallery
    try {
      await saveToGallery(pngBytes, context);
    } catch (e) {
      if (!context.mounted) return;
      _handleSaveError(context, e);
    }
  }

  /// Xử lý lỗi khi lưu QR code
  void _handleSaveError(final BuildContext context, final Object error) {
    if (!context.mounted) return;

    GlobalToast.showErrorToast(
      context,
      message: 'Lỗi khi lưu QR code',
    );
  }
}

