import 'package:flutter/material.dart';

import 'settings/settings_modal.dart';

class ButtonSettings extends StatelessWidget {
  final bool onAppbar;
  const ButtonSettings({super.key, this.onAppbar = false});

  void _showSettingsModal(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => const SettingsModal(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: () => _showSettingsModal(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: !onAppbar
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.settings,
          color: !onAppbar
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
