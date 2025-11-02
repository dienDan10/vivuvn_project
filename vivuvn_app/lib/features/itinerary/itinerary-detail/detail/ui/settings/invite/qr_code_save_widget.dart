import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Widget để hiển thị QR code với app name, logo để lưu thành ảnh
class QrCodeSaveWidget extends StatelessWidget {
  final String qrData;

  const QrCodeSaveWidget({
    super.key,
    required this.qrData,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 400,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.travel_explore,
              size: 40,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          // App Name
          Text(
            'ViVuVN',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Travel Vietnam',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // QR Code
          Container(
            width: 250,
            height: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: double.infinity,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            ),
          ),
        ],
      ),
    );
  }
}

