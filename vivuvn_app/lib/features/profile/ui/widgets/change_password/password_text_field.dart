import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/change_password_controller.dart';

class PasswordTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isCurrentPassword;
  final bool obscureText;
  final String? error;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.isCurrentPassword,
    required this.obscureText,
    this.error,
  });

  @override
  ConsumerState<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends ConsumerState<PasswordTextField> {
  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          onChanged: (final value) {
            if (!mounted) return;
            try {
              final changePasswordController = ref.read(changePasswordControllerProvider.notifier);
              if (widget.isCurrentPassword) {
                changePasswordController.setCurrentPassword(value);
              } else {
                changePasswordController.setNewPassword(value);
              }
            } catch (e) {
              // Widget was disposed, ignore
            }
          },
          obscureText: widget.obscureText,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.label,
            labelStyle: TextStyle(
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.6),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
        if (widget.error != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.error!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

