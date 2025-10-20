import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/budget_controller.dart';
import 'budget_item_tile.dart';

class ExpenseList extends ConsumerWidget {
  const ExpenseList({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(budgetControllerProvider);
    final expenses = state.items;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (expenses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Chưa có khoản chi tiêu nào',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: expenses.length,
      itemBuilder: (final context, final index) {
        final e = expenses[index];
        return BudgetItemTile(item: e);
      },
    );
  }
}
