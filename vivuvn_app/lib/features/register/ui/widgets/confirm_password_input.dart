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
      hintText: 'Xác nhận mật khẩu',
      keyboardType: TextInputType.text,
      controller: controller,
      validator: (final value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng xác nhận mật khẩu của bạn';
        }
        if (value != passwordController.text) {
          return 'Mật khẩu không khớp';
        }
        return null;
      },
    );
  }
}
