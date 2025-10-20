import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controller/budget_controller.dart';
import 'estimated_budget_form.dart';

class BudgetHeader extends ConsumerWidget {
  const BudgetHeader({super.key});

  void _openAddExpenseDialog(
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
    final formatter = NumberFormat('#,###', 'vi_VN');
    const fixedExchangeRate = 24000.0;

    final totalBudget = state.budget?.totalBudget ?? 0;
    final estimatedBudget = state.budget?.estimatedBudget ?? 0;
    final progressRaw = estimatedBudget > 0
        ? totalBudget / estimatedBudget
        : 0.0;
    final progress = progressRaw.clamp(0.0, 1.0);
    final progressPercent = (progressRaw * 100).clamp(0.0, double.infinity);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        children: [
          // Exchange rate display
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Tỷ giá tạm tính: 1 USD = ${formatter.format(fixedExchangeRate.round())} đ',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Total budget display - show both VND and USD
          Column(
            children: [
              Text(
                '${formatter.format(totalBudget.round())} đ',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '(≈ \$${(totalBudget / fixedExchangeRate).toStringAsFixed(2)})',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Tổng chi tiêu',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Progress bar
          if (estimatedBudget > 0) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${progressPercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: progressPercent > 100 ? Colors.red : null,
                      ),
                    ),
                    Text(
                      '${formatter.format(estimatedBudget.round())} đ',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress > 0.9
                          ? Colors.red
                          : progress > 0.7
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Estimated budget button - always show both VND and USD
          TextButton(
            onPressed: () => _openAddExpenseDialog(
              context,
              estimatedBudget > 0 ? estimatedBudget : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (estimatedBudget == 0)
                  const Text('Nhập ngân sách dự kiến')
                else ...[
                  // Always show both VND and USD with fixed exchange rate
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${formatter.format(estimatedBudget.round())} đ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '(≈ \$${(estimatedBudget / fixedExchangeRate).toStringAsFixed(2)})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit_outlined, size: 18),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
