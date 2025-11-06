import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controller/budget_controller.dart';
import 'statistics/controller/statistics_controller.dart';
import 'statistics/drag_handle.dart';
import 'statistics/statistics_chart.dart';
import 'statistics/statistics_empty_state.dart';
import 'statistics/statistics_modal_title.dart';
import 'statistics/statistics_subtitle.dart';
import 'statistics/statistics_toggle_group.dart';

/// Modal hiển thị thống kê chi tiêu
class StatisticsModal extends ConsumerWidget {
  const StatisticsModal({super.key});

  Map<String, double> _buildDataByType(
    final List<dynamic> items,
    final List<dynamic> types,
  ) {
    final data = <String, double>{};
    for (final type in types) {
      data[type.name] = 0.0;
    }
    for (final item in items) {
      data[item.budgetType] = (data[item.budgetType] ?? 0) + item.cost;
    }
    return data;
  }

  Map<String, double> _buildDataByDay(final List<dynamic> items) {
    final data = <String, double>{};
    for (final item in items) {
      final key = DateFormat('dd/MM/yyyy').format(item.date);
      data[key] = (data[key] ?? 0) + item.cost;
    }
    return data;
  }

  Map<String, double> _buildDataByMember(final List<dynamic> items) {
    final data = <String, double>{};
    for (final item in items) {
      final String key = (item.paidByMember?.username?.toString() ?? 'Không ai trả');
      data[key] = (data[key] ?? 0) + item.cost;
    }
    return data;
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final budgetState = ref.watch(budgetControllerProvider);
    final controller = ref.read(statisticsProvider.notifier);

    // Compute desired statistics from current budget state
    final itineraryId = budgetState.itineraryId;
    final dataByType = _buildDataByType(budgetState.items, budgetState.types);
    final dataByDay = _buildDataByDay(budgetState.items);
    final dataByMember = _buildDataByMember(budgetState.items);

    // Read current statistics for UI and to avoid redundant writes
    final statistics = ref.watch(statisticsProvider);

    // Defer provider mutations until after the frame to avoid lifecycle violations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      if (itineraryId != null && budgetState.types.isEmpty) {
        ref.read(budgetControllerProvider.notifier).loadBudgetTypes(itineraryId);
      }
      final current = ref.read(statisticsProvider);
      if (!mapEquals(current.dataByType, dataByType)) {
        controller.setDataByType(dataByType);
      }
      if (!mapEquals(current.dataByDay, dataByDay)) {
        controller.setDataByDay(dataByDay);
      }
      if (!mapEquals(current.dataByMember, dataByMember)) {
        controller.setDataByMember(dataByMember);
      }
    });
    final hasData = (statistics.showByType
            ? statistics.dataByType
            : statistics.dataByDay)
        .isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const DragHandle(),
          const SizedBox(height: 16),
          const StatisticsModalTitle(),
          const SizedBox(height: 20),
          const StatisticsToggleGroup(),
          const SizedBox(height: 20),
          const StatisticsSubtitle(),
          const SizedBox(height: 24),
          Expanded(
            child: hasData
                ? const StatisticsChart()
                : const StatisticsEmptyState(),
          ),
        ],
      ),
    );
  }
}
