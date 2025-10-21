import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/budget_controller.dart';
import '../../data/models/budget_items.dart';
import '../../utils/budget_constants.dart';
import '../../utils/expense_dialogs.dart';
import 'budget_item_tile.dart';

/// Widget hiển thị danh sách chi tiêu
class ExpenseList extends ConsumerWidget {
  final List<BudgetItem>? items;

  const ExpenseList({super.key, this.items});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(budgetControllerProvider);
    final expenses = items ?? state.items;

    // Loading state
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Empty state
    if (expenses.isEmpty) {
      return const _EmptyExpenseState();
    }

    // List of expenses
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: BudgetConstants.horizontalPadding,
      ),
      itemCount: expenses.length,
      itemBuilder: (final context, final index) {
        final expense = expenses[index];
        return BudgetItemTile(
          item: expense,
          onTap: () => ExpenseDialogs.showEditForm(context, expense),
          onDelete: () =>
              ExpenseDialogs.showDeleteConfirmation(context, ref, expense),
        );
      },
    );
  }
}

/// Widget hiển thị khi chưa có chi tiêu nào
class _EmptyExpenseState extends StatelessWidget {
  const _EmptyExpenseState();

  @override
  Widget build(final BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(BudgetConstants.sectionSpacing),
        child: Text(
          'Chưa có khoản chi tiêu nào',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
