import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerBackground extends StatelessWidget {
  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;

  const QrScannerBackground({super.key, required this.controller, required this.onDetect});

  @override
  Widget build(final BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: onDetect,
    );
  }
}


