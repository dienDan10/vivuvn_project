import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controller/budget_controller.dart';
import 'statistics/chart_data.dart';
import 'statistics/drag_handle.dart';
import 'statistics/statistics_chart.dart';
import 'statistics/statistics_empty_state.dart';
import 'statistics/statistics_modal_title.dart';
import 'statistics/statistics_subtitle.dart';
import 'statistics/statistics_toggle_buttons.dart';

/// Modal hiển thị thống kê chi tiêu
class StatisticsModal extends ConsumerStatefulWidget {
  const StatisticsModal({super.key});

  @override
  ConsumerState<StatisticsModal> createState() => _StatisticsModalState();
}

class _StatisticsModalState extends ConsumerState<StatisticsModal> {
  bool _showByType = true;
  String? _selectedKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itineraryId = ref.read(budgetControllerProvider).itineraryId;
      if (itineraryId != null) {
        ref
            .read(budgetControllerProvider.notifier)
            .loadBudgetTypes(itineraryId);
      }
    });
  }

  /// Tính toán data cho chart
  Map<String, double> _calculateDataMap() {
    final state = ref.read(budgetControllerProvider);
    final items = state.items;
    final types = state.types;
    final dataMap = <String, double>{};

    if (_showByType) {
      // Khởi tạo tất cả types với giá trị 0
      for (final type in types) {
        dataMap[type.name] = 0.0;
      }
      // Tính tổng chi tiêu cho từng type
      for (final item in items) {
        dataMap[item.budgetType] = (dataMap[item.budgetType] ?? 0) + item.cost;
      }
    } else {
      // Theo ngày
      for (final item in items) {
        final key = DateFormat('dd/MM/yyyy').format(item.date);
        dataMap[key] = (dataMap[key] ?? 0) + item.cost;
      }
    }

    return dataMap;
  }

  /// Chuyển đổi data map sang chart data
  List<ChartData> _toChartData(final Map<String, double> dataMap) {
    final entries = dataMap.entries.toList()
      ..sort((final a, final b) => b.value.compareTo(a.value));
    return entries.map((final e) => ChartData(e.key, e.value)).toList();
  }

  @override
  Widget build(final BuildContext context) {
    final dataMap = _calculateDataMap();
    final chartData = _toChartData(dataMap);

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
          StatisticsToggleButtons(
            showByType: _showByType,
            onToggle: (final value) {
              setState(() {
                _showByType = value;
                _selectedKey = null;
              });
            },
          ),
          const SizedBox(height: 20),
          StatisticsSubtitle(selectedKey: _selectedKey, dataMap: dataMap),
          const SizedBox(height: 24),
          Expanded(
            child: chartData.isEmpty
                ? const StatisticsEmptyState()
                : StatisticsChart(
                    chartData: chartData,
                    selectedKey: _selectedKey,
                    showByType: _showByType,
                    onBarTap: (final tappedKey) {
                      setState(() {
                        _selectedKey = _selectedKey == tappedKey
                            ? null
                            : tappedKey;
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
