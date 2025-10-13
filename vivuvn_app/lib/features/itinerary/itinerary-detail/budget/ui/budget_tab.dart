import 'package:flutter/material.dart';

import '../dialogs/budget-dialog/budget_dialog.dart';
import 'widgets/btn_add_budget_item.dart';
import 'widgets/budget_control.dart';
import 'widgets/budget_header.dart';
import 'widgets/list_expense.dart';

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  double _budget = 0;

  void _openBudgetDialog() async {
    final newBudget = await showBudgetDialog(context, _budget);
    if (newBudget != null) {
      setState(() => _budget = newBudget);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Total budget header
        BudgetHeader(
          budget: _budget,
          onSetBudget: _openBudgetDialog,
          backgroundColor: colorScheme.surface,
        ),

        // Budget controls
        const BudgetControl(),

        // Budget list
        const Expanded(child: ExpenseList()),

        // Add expense Button
        const ButtonAddBudgetItem(),
      ],
    );
  }
}
