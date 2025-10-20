import 'package:flutter/material.dart';

import '../../data/models/budget_items.dart' as model;

class BudgetItemTile extends StatelessWidget {
  final model.BudgetItem item;

  const BudgetItemTile({super.key, required this.item});

  String _formatDay(final DateTime dt) => '${dt.day}/${dt.month}';

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: const Icon(Icons.shopping_cart_outlined),
            title: Text(item.name),
            subtitle: Text('${_formatDay(item.date)} - ${item.budgetType}'),
            trailing: Text('${item.cost.toStringAsFixed(0)} đ'),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
