import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Subtitle text hiển thị số tiền được chọn
class StatisticsSubtitle extends StatelessWidget {
  const StatisticsSubtitle({
    required this.selectedKey,
    required this.dataMap,
    super.key,
  });

  final String? selectedKey;
  final Map<String, double> dataMap;

  @override
  Widget build(final BuildContext context) {
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
