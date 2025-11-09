import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/change_password_controller.dart';

class PasswordVisibilityToggle extends ConsumerStatefulWidget {
  final bool isCurrentPassword;
  final bool obscureText;

  const PasswordVisibilityToggle({
    super.key,
    required this.isCurrentPassword,
    required this.obscureText,
  });

  @override
  ConsumerState<PasswordVisibilityToggle> createState() =>
      _PasswordVisibilityToggleState();
}

class _PasswordVisibilityToggleState
    extends ConsumerState<PasswordVisibilityToggle> {
  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return IconButton(
      icon: Icon(
        widget.obscureText
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6),
      ),
      onPressed: () {
        if (!mounted) return;
        try {
          final changePasswordController =
              ref.read(changePasswordControllerProvider.notifier);
          if (widget.isCurrentPassword) {
            changePasswordController.toggleCurrentPasswordVisibility();
          } else {
            changePasswordController.toggleNewPasswordVisibility();
          }
        } catch (e) {
          // Widget was disposed, ignore
        }
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}

