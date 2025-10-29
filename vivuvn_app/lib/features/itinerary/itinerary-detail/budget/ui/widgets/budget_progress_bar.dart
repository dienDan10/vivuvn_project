import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/budget_constants.dart';

/// Widget hiển thị thanh progress bar cho ngân sách
class BudgetProgressBar extends StatelessWidget {
  final double totalBudget;
  final double estimatedBudget;

  const BudgetProgressBar({
    super.key,
    required this.totalBudget,
    required this.estimatedBudget,
  });

  /// Calculate progress ratio (0.0 to 1.0+)
  double get progressRaw =>
      estimatedBudget > 0 ? totalBudget / estimatedBudget : 0.0;

  /// Clamped progress for display (0.0 to 1.0)
  double get progress => progressRaw.clamp(0.0, 1.0);

  /// Progress percentage (can exceed 100%)
  double get progressPercent => (progressRaw * 100).clamp(0.0, double.infinity);

  /// Get progress color based on thresholds
  Color get progressColor {
    if (progress > BudgetConstants.dangerThreshold) return Colors.red;
    if (progress > BudgetConstants.warningThreshold) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(final BuildContext context) {
    if (estimatedBudget <= 0) return const SizedBox.shrink();

    final formatter = NumberFormat('#,###', 'vi_VN');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${progressPercent.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: progressPercent > 100 ? Colors.red : null,
              ),
            ),
            Text(
              '${formatter.format(estimatedBudget.round())} đ',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            BudgetConstants.progressBarRadius,
          ),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: BudgetConstants.progressBarHeight,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }
}
