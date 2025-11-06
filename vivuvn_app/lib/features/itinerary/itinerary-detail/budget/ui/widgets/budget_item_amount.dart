import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/budget_items.dart';
import '../../utils/budget_constants.dart';

class BudgetItemAmount extends StatelessWidget {
  final BudgetItem item;

  const BudgetItemAmount({super.key, required this.item});

  @override
  Widget build(final BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    final usdAmount = item.cost / BudgetConstants.exchangeRate;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${formatter.format(item.cost.round())} đ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '≈ \$${usdAmount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }
}


