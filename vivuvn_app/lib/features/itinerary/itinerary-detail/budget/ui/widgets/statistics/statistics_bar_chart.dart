import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/budget_type_icons.dart';
import 'chart_data.dart';

/// Statistics bar chart với avatar icons
class StatisticsBarChart extends StatelessWidget {
  const StatisticsBarChart({
    required this.chartData,
    required this.selectedKey,
    required this.onBarTap,
    super.key,
  });

  final List<ChartData> chartData;
  final String? selectedKey;
  final ValueChanged<String> onBarTap;

  @override
  Widget build(final BuildContext context) {
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
          onTap: () => onBarTap(data.category),
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
                    ? const Color(0xFF5B7FFF)
                    : const Color(0xFFB3C5FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            // Category name
            SizedBox(
              width: 100,
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF5B7FFF) : Colors.black87,
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
                      color: Colors.grey.shade100,
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
                                  const Color(0xFF5B7FFF),
                                  const Color(0xFF4A6FEE),
                                ]
                              : [
                                  const Color(0xFFB3C5FF),
                                  const Color(0xFF9AB5FF),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF5B7FFF,
                                  ).withOpacity(0.3),
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
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.white,
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
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF5B7FFF) : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
