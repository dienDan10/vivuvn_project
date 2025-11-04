import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/statistics_controller.dart';
import 'models/statistics_view_mode.dart';

/// Single toggle button widget that selects its own state from Riverpod
class StatisticsToggleButton extends ConsumerWidget {
  const StatisticsToggleButton({
    super.key,
    required this.label,
    required this.mode,
  });

  /// Label to display on the button
  final String label;

  /// The view mode this button represents
  final StatisticsViewMode mode;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isSelected = ref.watch(
      statisticsProvider.select((final s) {
        switch (mode) {
          case StatisticsViewMode.byType:
            return !s.showByMember && s.showByType;
          case StatisticsViewMode.byDay:
            return !s.showByMember && !s.showByType;
          case StatisticsViewMode.byMember:
            return s.showByMember;
        }
      }),
    );
    final controller = ref.read(statisticsProvider.notifier);

    return GestureDetector(
      onTap: () {
        switch (mode) {
          case StatisticsViewMode.byType:
            controller.setShowByType(true);
            break;
          case StatisticsViewMode.byDay:
            controller.setShowByType(false);
            break;
          case StatisticsViewMode.byMember:
            controller.setShowByMember(true);
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

