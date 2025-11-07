import 'package:flutter/material.dart';

import '../../../login/ui/widgets/text_input_global.dart';

class UsernameInput extends StatelessWidget {
  final TextEditingController controller;

  const UsernameInput({super.key, required this.controller});

  @override
  Widget build(final BuildContext context) {
    return TextInputGlobal(
      hintText: 'Tên người dùng',
      keyboardType: TextInputType.text,
      controller: controller,
      validator: (final value) =>
          value == null || value.isEmpty ? 'Nhập tên người dùng' : null,
    );
  }
}
