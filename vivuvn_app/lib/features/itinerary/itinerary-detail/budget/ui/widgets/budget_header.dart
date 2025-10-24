import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/budget_controller.dart';
import '../../utils/budget_constants.dart';
import 'budget_header_row.dart';
import 'budget_progress_bar.dart';
import 'estimated_budget_button.dart';
import 'estimated_budget_form.dart';
import 'statistics_modal.dart';
import 'total_budget_display.dart';

/// Header widget hiển thị tổng quan ngân sách
class BudgetHeader extends ConsumerWidget {
  const BudgetHeader({super.key});

  /// Mở statistics modal
  void _openStatisticsModal(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const StatisticsModal(),
    );
  }

  /// Mở estimated budget form
  void _openEstimatedBudgetForm(
    final BuildContext context,
    final double? currentEstimatedBudget,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EstimatedBudgetForm(
            initialEstimatedBudget: currentEstimatedBudget,
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(budgetControllerProvider);
    final totalBudget = state.budget?.totalBudget ?? 0;
    final estimatedBudget = state.budget?.estimatedBudget ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        // vertical: BudgetConstants.verticalPadding,
        horizontal: BudgetConstants.sectionSpacing,
      ),
      child: Column(
        children: [
          BudgetHeaderRow(
            onStatisticsPressed: () => _openStatisticsModal(context),
          ),
          const SizedBox(height: 8),
          TotalBudgetDisplay(totalBudget: totalBudget),
          const SizedBox(height: BudgetConstants.itemSpacing),
          BudgetProgressBar(
            totalBudget: totalBudget,
            estimatedBudget: estimatedBudget,
          ),
          if (estimatedBudget > 0) const SizedBox(height: 10),
          EstimatedBudgetButton(
            estimatedBudget: estimatedBudget,
            onPressed: () => _openEstimatedBudgetForm(
              context,
              estimatedBudget > 0 ? estimatedBudget : null,
            ),
          ),
        ],
      ),
    );
  }
}
