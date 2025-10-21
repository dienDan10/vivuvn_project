import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/budget_type_icons.dart';
import 'chart_data.dart';

/// Chart widget sử dụng Syncfusion
class StatisticsChart extends StatelessWidget {
  const StatisticsChart({
    required this.chartData,
    required this.selectedKey,
    required this.showByType,
    required this.onBarTap,
    super.key,
  });

  final List<ChartData> chartData;
  final String? selectedKey;
  final bool showByType;
  final ValueChanged<String> onBarTap;

  @override
  Widget build(final BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
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
        majorGridLines: MajorGridLines(width: 1, color: Colors.grey.shade200),
        axisLine: const AxisLine(width: 0),
        labelStyle: TextStyle(fontSize: 10, color: Colors.grey.shade600),
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
                ? const Color(0xFF5B7FFF)
                : const Color(0xFFB3C5FF);
          },
          borderRadius: BorderRadius.circular(4),
          spacing: 0.2,
          width: 0.6,
          animationDuration: 0,
          onPointTap: (final details) {
            final tappedKey = chartData[details.pointIndex!].category;
            onBarTap(tappedKey);
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
