import 'package:flutter/material.dart';

import '../../../../../../common/validator/validator.dart';

class FieldName extends StatelessWidget {
  final TextEditingController controller;

  const FieldName({super.key, required this.controller});

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.shopping_cart_outlined),
        labelText: 'Tên chi phí',
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      validator: (final value) {
        // Check empty
        final emptyError = Validator.notEmpty(value, fieldName: 'Tên chi phí');
        if (emptyError != null) return emptyError;

        // Check prohibited words
        if (Validator.containsSensitiveWords(value)) {
          return 'Tên chứa từ ngữ không được phép';
        }

        return null;
      },
    );
  }
}
