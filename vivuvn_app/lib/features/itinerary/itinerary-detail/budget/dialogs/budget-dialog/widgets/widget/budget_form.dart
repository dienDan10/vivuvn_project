import 'package:flutter/material.dart';

import 'budget_input_field.dart';
import 'submit_button.dart';

class BudgetForm extends StatefulWidget {
  final double initialBudget;

  const BudgetForm({super.key, required this.initialBudget});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialBudget.toStringAsFixed(0),
    );

    // tự động bật bàn phím khi mở dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final value = double.tryParse(_controller.text.trim());
    Navigator.pop(context, value);
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Đặt ngân sách',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Trường nhập ngân sách
            BudgetInputField(controller: _controller, focusNode: _focusNode),

            const SizedBox(height: 20),

            // Nút lưu
            SubmitButton(text: 'Lưu', onPressed: _onSubmit),
          ],
        ),
      ),
    );
  }
}
