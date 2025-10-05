import 'package:flutter/material.dart';

import '../../../login/ui/widgets/password_input_global.dart';

class ConfirmPasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;

  const ConfirmPasswordInput({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  @override
  Widget build(final BuildContext context) {
    return PasswordInputGlobal(
      hintText: 'Confirm Password',
      keyboardType: TextInputType.text,
      controller: controller,
      validator: (final value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
