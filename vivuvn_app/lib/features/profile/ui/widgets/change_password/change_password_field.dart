import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/change_password_controller.dart';
import 'password_field_container.dart';
import 'password_field_icon.dart';
import 'password_text_field.dart';
import 'password_visibility_toggle.dart';

class ChangePasswordField extends ConsumerStatefulWidget {
  final String label;
  final bool isCurrentPassword;

  const ChangePasswordField({
    super.key,
    required this.label,
    required this.isCurrentPassword,
  });

  @override
  ConsumerState<ChangePasswordField> createState() =>
      _ChangePasswordFieldState();
}

class _ChangePasswordFieldState
    extends ConsumerState<ChangePasswordField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(changePasswordControllerProvider);

    final obscureText = widget.isCurrentPassword
        ? state.obscureCurrentPassword
        : state.obscureNewPassword;
    final error = widget.isCurrentPassword
        ? state.currentPasswordError
        : state.newPasswordError;
    final currentValue = widget.isCurrentPassword
        ? state.currentPassword
        : state.newPassword;

    // Sync controller with state
    if (_controller.text != currentValue) {
      _controller.text = currentValue;
    }

    return PasswordFieldContainer(
      hasError: error != null,
      child: Row(
        children: [
          const PasswordFieldIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: PasswordTextField(
              controller: _controller,
              label: widget.label,
              isCurrentPassword: widget.isCurrentPassword,
              obscureText: obscureText,
              error: error,
            ),
          ),
          PasswordVisibilityToggle(
            isCurrentPassword: widget.isCurrentPassword,
            obscureText: obscureText,
          ),
        ],
      ),
    );
  }
}

