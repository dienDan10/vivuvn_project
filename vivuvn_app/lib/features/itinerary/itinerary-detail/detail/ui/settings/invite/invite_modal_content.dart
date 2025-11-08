import 'package:flutter/material.dart';

import 'invite_code_display.dart';
import 'qr_code_display_area.dart';
import 'save_qr_code_button.dart';

class InviteModalContent extends StatelessWidget {
  final ScrollController scrollController;

  const InviteModalContent({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(final BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Invite Code Section - nút lấy mã, mã mời và copy cùng hàng
            InviteCodeDisplay(),
            SizedBox(height: 24),
            // QR Code Section
            QrCodeDisplayArea(),
            SizedBox(height: 12),
            // Chỉ còn nút Save QR Code
            SaveQrCodeButton(),
            SizedBox(height: 16), // Bottom padding
          ],
        ),
      ),
    );
  }
}

