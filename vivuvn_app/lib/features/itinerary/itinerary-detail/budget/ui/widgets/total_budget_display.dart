import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/budget_constants.dart';

/// Widget hiển thị tổng chi tiêu với cả VND và USD
class TotalBudgetDisplay extends StatelessWidget {
  final double totalBudget;

  const TotalBudgetDisplay({super.key, required this.totalBudget});

  @override
  Widget build(final BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');

    return Column(
      children: [
        Text(
          '${formatter.format(totalBudget.round())} đ',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          '(≈ \$${(totalBudget / BudgetConstants.exchangeRate).toStringAsFixed(2)})',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Tổng chi tiêu',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}
