import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeImage extends StatelessWidget {
  final String data;

  const QrCodeImage({
    super.key,
    required this.data,
  });

  @override
  Widget build(final BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: double.infinity,
      backgroundColor: Colors.white,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
    );
  }
}

