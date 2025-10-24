import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/budget_controller.dart';
import '../../utils/budget_constants.dart';
import '../../utils/expense_dialogs.dart';
import 'budget_item_tile.dart';

/// Widget hiển thị danh sách chi tiêu
class ExpenseList extends ConsumerWidget {
  const ExpenseList({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final expenses = ref.watch(
      budgetControllerProvider.select((final state) => state.items),
    );

    final isLoading = ref.watch(
      budgetControllerProvider.select((final state) => state.isLoading),
    );

    // Loading state
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Empty state
    if (expenses.isEmpty) {
      return const _EmptyExpenseState();
    }

    // List of expenses
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
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
