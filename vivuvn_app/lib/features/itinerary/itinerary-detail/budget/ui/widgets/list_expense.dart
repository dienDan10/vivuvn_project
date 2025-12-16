import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
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
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Empty state
    if (expenses.isEmpty) {
      return const _EmptyExpenseState();
    }

    // List of expenses
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.itinerary?.isOwner ?? false,
      ),
    );

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: BudgetConstants.horizontalPadding,
        ),
        itemCount: expenses.length,
        itemBuilder: (final context, final index) {
          final expense = expenses[index];
          return BudgetItemTile(
            item: expense,
            onTap: isOwner
                ? () => ExpenseDialogs.showEditForm(context, expense)
                : null,
            onDelete: isOwner
                ? () => ExpenseDialogs.showDeleteConfirmation(
                      context,
                      ref,
                      expense,
                    )
                : null,
          );
        },
      ),
    );
  }
}

/// Widget hiển thị khi chưa có chi tiêu nào
class _EmptyExpenseState extends StatelessWidget {
  const _EmptyExpenseState();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(BudgetConstants.sectionSpacing),
          child: Text(
            'Chưa có khoản chi tiêu nào',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color
                  ?.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
