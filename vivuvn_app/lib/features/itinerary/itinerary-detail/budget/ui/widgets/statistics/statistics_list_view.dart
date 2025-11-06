import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/statistics_controller.dart';
import 'statistics_list_item.dart';

/// Statistics list với avatar icons
class StatisticsListView extends ConsumerWidget {
  const StatisticsListView({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itemCount = ref.watch(
      statisticsProvider.select((final s) => s.chartData.length),
    );
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: itemCount,
      separatorBuilder: (final context, final index) =>
          const SizedBox(height: 8),
      itemBuilder: (final context, final index) {
        return StatisticsListItem(index: index);
      },
    );
  }
}
