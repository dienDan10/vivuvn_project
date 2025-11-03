
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../controller/join_itinerary_controller.dart';
import 'painters/scan_window_painter.dart';
import 'widgets/qr_overlay_frame.dart';
import 'widgets/qr_overlay_hint.dart';
import 'widgets/qr_scanner_background.dart';

class ScanQrPage extends ConsumerStatefulWidget {
  const ScanQrPage({super.key});

  @override
  ConsumerState<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends ConsumerState<ScanQrPage> with TickerProviderStateMixin {
  late final MobileScannerController _controller;
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [BarcodeFormat.qrCode],
    );
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scanController.dispose();
    super.dispose();
  }

  void _onDetect(final BarcodeCapture capture) {
    ref
        .read(joinItineraryControllerProvider.notifier)
        .handleQrDetect(context, capture);
  }

  Future<void> _pickFromGallery() async {
    await ref
        .read(joinItineraryControllerProvider.notifier)
        .pickFromGalleryAndDecode(context: context, scanner: _controller);
  }

  @override
  Widget build(final BuildContext context) {
    const overlaySize = 240.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        actions: [
          IconButton(
            tooltip: 'Mở ảnh từ thư viện',
            onPressed: _pickFromGallery,
            icon: const Icon(Icons.photo_library_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          QrScannerBackground(controller: _controller, onDetect: _onDetect),
          IgnorePointer(
            child: Center(
              child: CustomPaint(
                painter: ScanWindowPainter(windowSize: overlaySize),
                child: const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          QrOverlayFrame(scanAnimation: _scanController),
          const QrOverlayHint(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickFromGallery,
        icon: const Icon(Icons.photo_library_outlined),
        label: const Text('Chọn ảnh QR'),
      ),
    );
  }
}

