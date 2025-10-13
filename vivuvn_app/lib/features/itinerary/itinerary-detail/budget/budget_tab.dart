import 'package:flutter/material.dart';

import 'budget_header.dart';
import 'dialogs/add-expense/add_expense_dialog.dart';
import 'dialogs/budget-dialog/budget_dialog.dart';
import 'list_expense.dart';

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  double _budget = 0;
  final List<Map<String, dynamic>> _expenses = [
    {'name': 'Tên chi phí', 'amount': 10000, 'type': 'Ăn uống', 'day': '1/10'},
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

  void _openBudgetDialog() async {
    final newBudget = await showBudgetDialog(context, _budget);
    if (newBudget != null) {
      setState(() => _budget = newBudget);
    }
  }

  void _openAddExpenseDialog() async {
    final newExpense = await showAddExpenseDialog(context);
    if (newExpense != null) {
      setState(() => _expenses.add(newExpense));
    }
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        BudgetHeader(
          budget: _budget,
          onSetBudget: _openBudgetDialog,
          backgroundColor: colorScheme.surface,
        ),
        Expanded(
          child: ExpenseList(
            expenses: _expenses,
            onAddExpense: _openAddExpenseDialog,
          ),
        ),
      ],
    );
  }
}
