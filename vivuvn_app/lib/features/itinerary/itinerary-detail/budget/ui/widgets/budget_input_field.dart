import 'package:flutter/material.dart';

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
      validator: (final value) {
        // Allow empty (will be treated as 0)
        if (value == null || value.trim().isEmpty) {
          return null;
        }
        // Only validate if not empty
        final amount = double.tryParse(value.replaceAll(',', '').trim());
        if (amount == null) {
          return 'Số tiền không hợp lệ';
        }
        if (amount < 0) {
          return 'Số tiền không được âm';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
