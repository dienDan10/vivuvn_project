import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/budget_type_icons.dart';
import 'controller/statistics_controller.dart';
import 'models/chart_data.dart';

/// Chart widget sử dụng Syncfusion
class StatisticsChart extends ConsumerWidget {
  const StatisticsChart({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(statisticsProvider);
    final chartData = state.chartData;
    final selectedKey = state.selectedKey;
    final showByType = state.showByType;
    final controller = ref.read(statisticsProvider.notifier);
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
        // Custom label với icon
        axisLabelFormatter: (final AxisLabelRenderDetails details) {
          if (!showByType) {
            return ChartAxisLabel(details.text, details.textStyle);
          }

          final icon = BudgetTypeIcons.getIconForType(details.text);
          return ChartAxisLabel(
            String.fromCharCode(icon.codePoint),
            details.textStyle.copyWith(
              fontFamily: icon.fontFamily,
              fontSize: 20,
            ),
          );
        },
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(
          width: 1,
          color: theme.dividerColor,
        ),
        axisLine: const AxisLine(width: 0),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          color: theme.textTheme.bodySmall?.color
              ?.withValues(alpha: 0.7),
        ),
        numberFormat: NumberFormat('#,###', 'vi_VN'),
        labelFormat: '{value} ₫',
      ),
      series: <CartesianSeries>[
        BarSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (final data, final _) => data.category,
          yValueMapper: (final data, final _) => data.value,
          pointColorMapper: (final data, final _) {
            return selectedKey == data.category
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary;
          },
          borderRadius: BorderRadius.circular(4),
          spacing: 0.2,
          width: 0.6,
          animationDuration: 0,
          onPointTap: (final details) {
            final tappedKey = chartData[details.pointIndex!].category;
            controller.selectKey(tappedKey);
          },
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x: point.y VND',
        textStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}
