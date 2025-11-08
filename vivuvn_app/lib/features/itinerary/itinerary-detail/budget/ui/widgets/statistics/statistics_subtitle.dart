import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'controller/statistics_controller.dart';

/// Subtitle text hiển thị số tiền được chọn
class StatisticsSubtitle extends ConsumerWidget {
  const StatisticsSubtitle({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(statisticsProvider);
    final selectedKey = state.selectedKey;
    final dataMap = state.showByMember
        ? state.dataByMember
        : (state.showByType ? state.dataByType : state.dataByDay);
    return Text(
      selectedKey == null
          ? 'Chọn một mục để xem chi tiết'
          : '$selectedKey: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(dataMap[selectedKey] ?? 0)}',
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
