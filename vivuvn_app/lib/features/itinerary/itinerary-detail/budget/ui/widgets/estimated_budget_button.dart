import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/budget_constants.dart';

/// Button để thêm/chỉnh sửa ngân sách dự kiến
class EstimatedBudgetButton extends StatelessWidget {
  final double estimatedBudget;
  final VoidCallback? onPressed;

  const EstimatedBudgetButton({
    super.key,
    required this.estimatedBudget,
    this.onPressed,
  });

  @override
  Widget build(final BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (estimatedBudget == 0)
            const Text(
              'Nhập ngân sách dự kiến',
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${formatter.format(estimatedBudget.round())} đ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '(≈ \$${(estimatedBudget / BudgetConstants.exchangeRate).toStringAsFixed(2)})',
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
          ],
        ],
      ),
    );
  }
}
