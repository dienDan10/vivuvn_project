import 'package:flutter/material.dart';

import '../../../../../../../common/validator/validator.dart';

class FieldAmount extends StatelessWidget {
  final TextEditingController controller;

  const FieldAmount({super.key, required this.controller});

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.attach_money),
        labelText: 'Số tiền',
        border: OutlineInputBorder(),
      ),
      validator: (final value) => Validator.money(value, fieldName: 'amount'),
    );
  }
}
