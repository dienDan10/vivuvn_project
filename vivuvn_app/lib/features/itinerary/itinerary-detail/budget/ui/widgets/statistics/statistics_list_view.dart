import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/budget_type_icons.dart';
import 'chart_data.dart';

/// Statistics list với avatar icons
class StatisticsListView extends StatelessWidget {
  const StatisticsListView({
    required this.chartData,
    required this.selectedKey,
    required this.onItemTap,
    super.key,
  });

  final List<ChartData> chartData;
  final String? selectedKey;
  final ValueChanged<String> onItemTap;

  @override
  Widget build(final BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: chartData.length,
      separatorBuilder: (final context, final index) =>
          const SizedBox(height: 8),
      itemBuilder: (final context, final index) {
        final data = chartData[index];
        final isSelected = selectedKey == data.category;
        final icon = BudgetTypeIcons.getIconForType(data.category);

        return _StatisticsListItem(
          category: data.category,
          value: data.value,
          icon: icon,
          isSelected: isSelected,
          onTap: () => onItemTap(data.category),
        );
      },
    );
  }
}

/// Single statistics list item
class _StatisticsListItem extends StatelessWidget {
  const _StatisticsListItem({
    required this.category,
    required this.value,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String category;
  final double value;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5B7FFF).withOpacity(0.1)
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
                category,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF5B7FFF) : Colors.black87,
                ),
              ),
            ),
            // Amount
            Text(
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(value),
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
