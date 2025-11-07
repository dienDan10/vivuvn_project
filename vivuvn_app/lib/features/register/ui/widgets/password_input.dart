import 'package:flutter/material.dart';

import '../../../../common/validator/validator.dart';
import '../../../login/ui/widgets/password_input_global.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;

  const PasswordInput({super.key, required this.controller});

  @override
  Widget build(final BuildContext context) {
    return PasswordInputGlobal(
      hintText: 'Mật khẩu',
      keyboardType: TextInputType.text,
      controller: controller,
      validator: Validator.validatePassword,
    );
  }
}
