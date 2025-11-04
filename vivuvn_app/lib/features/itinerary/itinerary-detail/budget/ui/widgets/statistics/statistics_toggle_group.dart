import 'package:flutter/material.dart';

import 'models/statistics_view_mode.dart';
import 'statistics_toggle_button.dart';

/// Toggle buttons group để chuyển đổi giữa Category, Day by day và Member
class StatisticsToggleGroup extends StatelessWidget {
  const StatisticsToggleGroup({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(
            child: StatisticsToggleButton(
              label: 'Theo loại chi phí',
              mode: StatisticsViewMode.byType,
            ),
          ),
          Expanded(
            child: StatisticsToggleButton(
              label: 'Theo ngày',
              mode: StatisticsViewMode.byDay,
            ),
          ),
          Expanded(
            child: StatisticsToggleButton(
              label: 'Theo thành viên',
              mode: StatisticsViewMode.byMember,
            ),
          ),
        ],
      ),
    );
  }
}
