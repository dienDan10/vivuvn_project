import 'package:flutter/material.dart';

import 'widgets/field_amount.dart';
import 'widgets/field_date.dart';
import 'widgets/field_name.dart';
import 'widgets/field_type.dart';
import 'widgets/submit_button.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({super.key});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  String selectedType = 'Chưa chọn';
  DateTime? selectedDate;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final expense = {
      'name': nameController.text.trim(),
      'amount': double.tryParse(amountController.text) ?? 0,
      'type': selectedType,
      'day': selectedDate == null
          ? '—'
          : '${selectedDate!.day}/${selectedDate!.month}',
    };
    Navigator.pop(context, expense);
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thêm chi phí',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              FieldName(controller: nameController),
              const SizedBox(height: 12),

              FieldAmount(controller: amountController),
              const SizedBox(height: 12),

              FieldType(
                selectedType: selectedType,
                onSelected: (final value) =>
                    setState(() => selectedType = value ?? selectedType),
              ),
              const SizedBox(height: 12),

              FieldDate(
                selectedDate: selectedDate,
                onSelected: (final date) =>
                    setState(() => selectedDate = date ?? selectedDate),
              ),
              const SizedBox(height: 16),

              SubmitButton(text: 'Xong', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
