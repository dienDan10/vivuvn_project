import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../utils/budget_type_icons.dart';
import 'controller/statistics_controller.dart';

/// Statistics bar chart với avatar icons
class StatisticsBarChart extends ConsumerWidget {
  const StatisticsBarChart({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(statisticsProvider);
    final controller = ref.read(statisticsProvider.notifier);
    final chartData = state.chartData;
    final selectedKey = state.selectedKey;
    if (chartData.isEmpty) return const SizedBox.shrink();

    // Tìm giá trị max để scale bars
    final maxValue = chartData
        .map((final d) => d.value)
        .reduce((final a, final b) => a > b ? a : b);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: chartData.length,
      separatorBuilder: (final context, final index) =>
          const SizedBox(height: 12),
      itemBuilder: (final context, final index) {
        final data = chartData[index];
        final isSelected = selectedKey == data.category;
        final icon = BudgetTypeIcons.getIconForType(data.category);
        final barWidth = (data.value / maxValue).clamp(0.05, 1.0);

        return _StatisticsBarItem(
          category: data.category,
          value: data.value,
          icon: icon,
          isSelected: isSelected,
          barWidth: barWidth,
          onTap: () => controller.selectKey(data.category),
        );
      },
    );
  }
}

/// Single bar chart item với avatar
class _StatisticsBarItem extends StatelessWidget {
  const _StatisticsBarItem({
    required this.category,
    required this.value,
    required this.icon,
    required this.isSelected,
    required this.barWidth,
    required this.onTap,
  });

  final String category;
  final double value;
  final IconData icon;
  final bool isSelected;
  final double barWidth;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            // Avatar icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Category name
            SizedBox(
              width: 100,
              child: Text(
                category,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Bar chart
            Expanded(
              child: Stack(
                children: [
                  // Background bar
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Filled bar
                  FractionallySizedBox(
                    widthFactor: barWidth,
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primaryContainer,
                                ]
                              : [
                                  theme.colorScheme.secondary,
                                  theme.colorScheme.secondaryContainer,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        NumberFormat.compact(locale: 'vi_VN').format(value),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Amount text
            SizedBox(
              width: 80,
              child: Text(
                NumberFormat.compact(locale: 'vi_VN').format(value),
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
