import 'package:flutter/material.dart';

import '../../../../../../common/validator/validator.dart';

class BudgetInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onChanged;

  const BudgetInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.attach_money),
        border: OutlineInputBorder(),
        labelText: 'Số tiền',
      ),
      validator: (final value) =>
          Validator.moneyOrZero(value, fieldName: 'Budget'),
      onChanged: onChanged,
    );
  }
}
