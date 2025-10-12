import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;
  final VoidCallback onAddExpense;

  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onAddExpense,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Các chi phí',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Row(
                children: [
                  Text('sắp xếp: Ngày (mới nhất)'),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: expenses.length,
            itemBuilder: (final context, final index) {
              final e = expenses[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.shopping_cart_outlined),
                  title: Text(e['name']),
                  subtitle: Text("${e["day"]} - ${e["type"]}"),
                  trailing: Text("${e["amount"].toStringAsFixed(0)} đ"),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: OutlinedButton.icon(
            onPressed: onAddExpense,
            icon: const Icon(Icons.add),
            label: const Text('Thêm khoản phí'),
          ),
        ),
      ],
    );
  }
}
