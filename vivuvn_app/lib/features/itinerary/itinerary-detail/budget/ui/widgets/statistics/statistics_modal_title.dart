import 'package:flutter/material.dart';

/// Modal title widget
class StatisticsModalTitle extends StatelessWidget {
  const StatisticsModalTitle({super.key});

  @override
  Widget build(final BuildContext context) {
    return Text(
      'Thống kê chi tiêu',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }
}
