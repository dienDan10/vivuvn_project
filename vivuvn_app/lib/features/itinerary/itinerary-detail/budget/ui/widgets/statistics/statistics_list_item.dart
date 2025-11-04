import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../utils/budget_type_icons.dart';
import 'controller/statistics_controller.dart';

class StatisticsListItem extends ConsumerWidget {
  const StatisticsListItem({super.key, required this.index});

  final int index;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final data = ref.watch(
      statisticsProvider.select((final s) => s.chartData[index]),
    );
    final isSelected = ref.watch(
      statisticsProvider.select((final s) => s.selectedKey == data.category),
    );
    final controller = ref.read(statisticsProvider.notifier);
    final icon = BudgetTypeIcons.getIconForType(data.category);

    return InkWell(
      onTap: () => controller.selectKey(data.category),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5B7FFF).withValues(alpha: 0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5B7FFF)
                    : const Color(0xFFB3C5FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            // Category name
            Expanded(
              child: Text(
                data.category,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF5B7FFF) : Colors.black87,
                ),
              ),
            ),
            // Amount
            Text(
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                  .format(data.value),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF5B7FFF) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


