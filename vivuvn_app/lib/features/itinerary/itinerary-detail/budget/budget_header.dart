import 'package:flutter/material.dart';

class BudgetHeader extends StatelessWidget {
  final double budget;
  final VoidCallback onSetBudget;
  final Color backgroundColor;

  const BudgetHeader({
    super.key,
    required this.budget,
    required this.onSetBudget,
    required this.backgroundColor,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            '${budget.toStringAsFixed(0)} đ',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onSetBudget,
            child: const Text('Đặt ngân sách'),
          ),
        ],
      ),
    );
  }
}
