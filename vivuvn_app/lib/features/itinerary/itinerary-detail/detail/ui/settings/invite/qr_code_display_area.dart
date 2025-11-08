import 'package:flutter/material.dart';

import 'qr_code_container.dart';
import 'qr_code_description_text.dart';

class QrCodeDisplayArea extends StatelessWidget {
  const QrCodeDisplayArea({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrCodeContainer(),
          SizedBox(height: 8),
          QrCodeDescriptionText(),
        ],
      ),
    );
  }
}

