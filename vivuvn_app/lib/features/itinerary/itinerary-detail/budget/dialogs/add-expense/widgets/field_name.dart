import 'package:flutter/material.dart';

import '../../../../../../../common/validator/validator.dart';

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
        border: OutlineInputBorder(),
      ),
      validator: (final value) =>
          Validator.notEmpty(value, fieldName: 'budget name'),
    );
  }
}
