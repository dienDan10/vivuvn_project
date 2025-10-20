import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';
import '../controller/budget_controller.dart';
import 'widgets/btn_add_budget_item.dart';
import 'widgets/budget_control.dart';
import 'widgets/budget_header.dart';
import 'widgets/list_expense.dart';

class BudgetTab extends ConsumerStatefulWidget {
  const BudgetTab({super.key});

  @override
  ConsumerState<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends ConsumerState<BudgetTab> {
  @override
  void initState() {
    super.initState();
    // Load budget when tab is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itineraryId = ref
          .read(itineraryDetailControllerProvider)
          .itineraryId;
      if (itineraryId != null) {
        ref.read(budgetControllerProvider.notifier).loadBudget(itineraryId);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return const Column(
      children: [
        // Total budget header
        BudgetHeader(),

        // Budget controls
        BudgetControl(),

        // Budget list
        Expanded(child: ExpenseList()),

        // Add expense Button
        ButtonAddBudgetItem(),
      ],
    );
  }
}
