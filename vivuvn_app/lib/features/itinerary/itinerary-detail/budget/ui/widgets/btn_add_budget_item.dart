import 'package:flutter/material.dart';

import 'add_expense_form.dart';

class ButtonAddBudgetItem extends StatelessWidget {
  const ButtonAddBudgetItem({super.key});

  void _openAddExpenseDialog(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddExpenseForm(),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: OutlinedButton.icon(
        onPressed: () => _openAddExpenseDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm khoản phí'),
      ),
    );
  }
}
