import 'package:flutter/material.dart';

class BudgetItem extends StatelessWidget {
  final Map<String, dynamic> expense;

  const BudgetItem({super.key, required this.expense});

  @override
  Widget build(final BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.shopping_cart_outlined),
        title: Text(expense['name']),
        subtitle: Text("${expense["day"]} - ${expense["type"]}"),
        trailing: Text("${expense["amount"].toStringAsFixed(0)} đ"),
      ),
    );
  }
}
