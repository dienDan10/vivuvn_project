import 'package:flutter/material.dart';

import '../../data/models/budget_items.dart';

class BudgetItemSubtitle extends StatelessWidget {
  final BudgetItem item;

  const BudgetItemSubtitle({super.key, required this.item});

  @override
  Widget build(final BuildContext context) {
    final baseStyle = TextStyle(fontSize: 13, color: Colors.grey[600]);
    final payer = item.paidByMember;

    final top = Text(
      '${_formatDay(item.date)} • ${item.budgetType}',
      style: baseStyle,
    );

    if (payer == null) {
      return top;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        top,
        const SizedBox(height: 2),
        Text(
          'Trả bởi: ${payer.username}',
          style: baseStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _formatDay(final DateTime dt) => '${dt.day}/${dt.month}';
}


