import 'package:flutter/material.dart';

import 'exchange_rate_display.dart';

/// Header row với exchange rate và statistics button
class BudgetHeaderRow extends StatelessWidget {
  const BudgetHeaderRow({required this.onStatisticsPressed, super.key});

  final VoidCallback onStatisticsPressed;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ExchangeRateDisplay(),
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.bar_chart_outlined),
          tooltip: 'Thống kê',
          onPressed: onStatisticsPressed,
        ),
      ],
    );
  }
}
