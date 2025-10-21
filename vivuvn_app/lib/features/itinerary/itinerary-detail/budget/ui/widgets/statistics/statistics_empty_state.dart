import 'package:flutter/material.dart';

/// Empty state widget khi không có dữ liệu
class StatisticsEmptyState extends StatelessWidget {
  const StatisticsEmptyState({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Center(
      child: Text('No data available', style: TextStyle(color: Colors.grey)),
    );
  }
}
