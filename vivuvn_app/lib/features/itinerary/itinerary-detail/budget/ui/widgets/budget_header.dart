import 'package:flutter/material.dart';

import 'budget_form.dart';

class BudgetHeader extends StatelessWidget {
  const BudgetHeader({super.key});

  void _openAddExpenseDialog(final BuildContext context) {
    showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const BudgetForm(),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const Text(
            '0 đ',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          TextButton(
            onPressed: () => _openAddExpenseDialog(context),
            child: const Text('Đặt ngân sách'),
          ),
        ],
      ),
    );
  }
}
