import 'package:flutter/material.dart';

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
  final double _budget = 0;

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return const Column(
      children: [
        // Total budget header
        BudgetHeader(),

        // Budget controls
        BudgetControl(),

        // Budget list
        Expanded(child: ExpenseList()),

        // Add expense Button
        ButtonAddBudgetItem(),
      ],
    );
  }
}
