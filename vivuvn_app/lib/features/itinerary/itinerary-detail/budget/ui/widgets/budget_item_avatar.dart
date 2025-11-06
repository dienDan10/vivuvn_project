import 'package:flutter/material.dart';

import '../../data/models/budget_items.dart';
import '../../utils/budget_type_icons.dart';

class BudgetItemAvatar extends StatelessWidget {
  final BudgetItem item;

  const BudgetItemAvatar({super.key, required this.item});

  @override
  Widget build(final BuildContext context) {
    final icon = BudgetTypeIcons.getIconForType(item.budgetType);
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
    );
  }
}


