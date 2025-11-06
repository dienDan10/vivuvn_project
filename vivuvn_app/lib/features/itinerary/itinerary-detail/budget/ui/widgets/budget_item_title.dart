import 'package:flutter/material.dart';

import '../../data/models/budget_items.dart';

class BudgetItemTitle extends StatelessWidget {
  final BudgetItem item;

  const BudgetItemTitle({super.key, required this.item});

  @override
  Widget build(final BuildContext context) {
    return Text(
      item.name,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      overflow: TextOverflow.ellipsis,
    );
  }
}


