import 'package:flutter/material.dart';

import '../settings_modal.dart';

class InviteModalBackButton extends StatelessWidget {
  const InviteModalBackButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop(); // Đóng invite modal
        // Hiển thị lại settings modal
        final navigatorContext = context;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (navigatorContext.mounted) {
            showModalBottomSheet(
              context: navigatorContext,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: true,
              enableDrag: true,
              barrierColor: Colors.black.withValues(alpha: 0.3),
              builder: (final context) => const SettingsModal(),
            );
          }
        });
      },
    );
  }
}

