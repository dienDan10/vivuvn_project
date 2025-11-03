import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zxing2/qrcode.dart' as zqr;
import 'package:zxing2/zxing2.dart' as zxing;

import '../../../../common/toast/global_toast.dart';
import '../../../../common/validator/validation_exception.dart';
import '../../../../common/validator/validator.dart';
import '../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../view-itinerary-list/controller/itinerary_controller.dart';
import '../services/join_itinerary_service.dart';
import '../state/join_itinerary_state.dart';
import '../ui/scan_qr_page.dart';

class JoinItineraryController extends AutoDisposeNotifier<JoinItineraryState> {
  @override
  build() {
    return JoinItineraryState();
  }

  void setInviteCode(final String code) {
    state = state.copyWith(inviteCode: code, error: null);
  }

  void setPickedImagePath(final String? path) {
    state = state.copyWith(pickedImagePath: path);
  }

  void setScanHandled(final bool handled) {
    state = state.copyWith(isScanHandled: handled);
  }

  void setDecodingImage(final bool value) {
    state = state.copyWith(isDecodingImage: value);
  }

  Future<void> join() async {
    try {
      _validate();
      state = state.copyWith(isLoading: true, error: null);

      final service = ref.read(joinItineraryServiceProvider);
      await service.joinByInviteCode(state.inviteCode.trim());
    } on ValidationException catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
      rethrow;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _validate() {
    final code = state.inviteCode;
    if (code.trim().isEmpty) {
      throw ValidationException('Mã mời không được để trống');
    }
    if (Validator.containsSensitiveWords(code)) {
      throw ValidationException('Mã mời chứa từ cấm');
    }
  }

  Future<void> scanQrAndSetInviteCode(final BuildContext context) async {
    try {
      // reset previous scan state before opening scanner
      setPickedImagePath(null);
      setScanHandled(false);
      final result = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (final _) => const ScanQrPage(),
        ),
      );
      if (result != null && result.isNotEmpty) {
        setInviteCode(result);
        // clear scan state after a successful scan
        setPickedImagePath(null);
        setScanHandled(false);
      }
    } catch (e) {
      state = state.copyWith(error: 'Không thể quét QR: $e');
    }
  }

  Future<void> handleJoinPressed(final BuildContext context) async {
    try {
      final navigator = Navigator.of(context);
      await join();
      if (navigator.canPop()) {
        navigator.pop();
      }
      await ref.read(itineraryControllerProvider.notifier).fetchItineraries();
    } catch (_) {
      // error is already reflected in state and listened by UI for toasts
    }
  }

  void handleQrDetect(final BuildContext context, final BarcodeCapture capture) {
    if (state.isScanHandled) return;
    final codes = capture.barcodes;
    if (codes.isEmpty) return;
    final raw = codes.first.rawValue;
    if (raw == null || raw.isEmpty) return;
    setScanHandled(true);
    // Clear preview image before dismissing the scanner UI
    setPickedImagePath(null);
    Navigator.of(context).pop(raw);
  }

  Future<void> pickFromGalleryAndDecode({
    required final BuildContext context,
    required final MobileScannerController scanner,
  }) async {
    try {
      setDecodingImage(true);
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;
      setPickedImagePath(file.path);
      setScanHandled(false);
      await scanner.analyzeImage(file.path);

      // Wait briefly for the decode callback to possibly trigger
      const totalWait = Duration(milliseconds: 700);
      const step = Duration(milliseconds: 70);
      var waited = Duration.zero;
      while (!state.isScanHandled && waited < totalWait) {
        await Future.delayed(step);
        waited += step;
      }

      if (!state.isScanHandled) {
        final decoded = await _fallbackDecodeQr(file.path);
        if (decoded != null && decoded.isNotEmpty && context.mounted) {
          setScanHandled(true);
          setPickedImagePath(null);
          Navigator.of(context).pop(decoded);
        } else {
          if (!context.mounted) return;
          GlobalToast.showErrorToast(context, message: 'Ảnh không chứa mã QR hợp lệ');
        }
      }
    } catch (_) {
      if (!context.mounted) return;
      GlobalToast.showErrorToast(context, message: 'Không thể đọc ảnh QR từ thư viện');
    }
    finally {
      setDecodingImage(false);
    }
  }

  Future<String?> _fallbackDecodeQr(final String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final width = image.width;
      final height = image.height;
      final raw = image.getBytes(order: img.ChannelOrder.rgba);

      final length = width * height;
      final pixels = Int32List(length);
      var p = 0;
      for (var i = 0; i < length; i++) {
        final r = raw[p++];
        final g = raw[p++];
        final b = raw[p++];
        final a = raw[p++];
        pixels[i] = (a << 24) | (r << 16) | (g << 8) | b;
      }

      final source = zxing.RGBLuminanceSource(width, height, pixels);
      final bitmap = zxing.BinaryBitmap(zxing.HybridBinarizer(source));
      final reader = zqr.QRCodeReader();
      final result = reader.decode(bitmap);
      return result.text;
    } catch (_) {
      return null;
    }
  }
}

final joinItineraryControllerProvider = AutoDisposeNotifierProvider<
    JoinItineraryController,
    JoinItineraryState>(() => JoinItineraryController());


