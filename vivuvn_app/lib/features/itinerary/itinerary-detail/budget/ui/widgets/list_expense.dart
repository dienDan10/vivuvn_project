import 'package:flutter/material.dart';

import 'budget_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(final BuildContext context) {
    final List<Map<String, dynamic>> expenses = [
      {
        'name': 'Tên chi phí',
        'amount': 10000,
        'type': 'Ăn uống',
        'day': '1/10',
      },
      {
        'name': 'Tên chi phí',
        'amount': 10000,
        'type': 'Di chuyển',
        'day': '2/10',
      },
      {
        'name': 'Tên chi phí',
        'amount': 10000,
        'type': 'Khách sạn',
        'day': '3/10',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: expenses.length,
      itemBuilder: (final context, final index) {
        final e = expenses[index];
        return BudgetItem(expense: e);
      },
    );
  }
}
