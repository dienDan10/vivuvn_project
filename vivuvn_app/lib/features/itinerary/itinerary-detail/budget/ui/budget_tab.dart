import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';
import '../controller/budget_controller.dart';
import '../utils/budget_sorter.dart';
import 'widgets/btn_add_budget_item.dart';
import 'widgets/budget_control.dart';
import 'widgets/budget_header.dart';
import 'widgets/list_expense.dart';

/// Main budget tab widget with sorting and CRUD operations
class BudgetTab extends ConsumerStatefulWidget {
  const BudgetTab({super.key});

  @override
  ConsumerState<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends ConsumerState<BudgetTab> {
  BudgetSortOption _currentSort = BudgetSortOption.dateNewest;

  @override
  void initState() {
    super.initState();
    _loadBudgetData();
  }

  /// Load budget data when tab is first opened
  void _loadBudgetData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itineraryId = ref
          .read(itineraryDetailControllerProvider)
          .itineraryId;
      if (itineraryId != null) {
        ref.read(budgetControllerProvider.notifier).loadBudget(itineraryId);
      }
    });
  }

  /// Handle sort option change
  void _handleSortChange(final BudgetSortOption option) {
    setState(() {
      _currentSort = option;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final budgetState = ref.watch(budgetControllerProvider);
    final sortedItems = BudgetSorter.sort(budgetState.items, _currentSort);

    return Scaffold(
      body: Column(
        children: [
          const BudgetHeader(),
          BudgetControl(
            currentSort: _currentSort,
            onSortChanged: _handleSortChange,
          ),
          Expanded(child: ExpenseList(items: sortedItems)),
        ],
      ),
      floatingActionButton: const ButtonAddBudgetItem(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
