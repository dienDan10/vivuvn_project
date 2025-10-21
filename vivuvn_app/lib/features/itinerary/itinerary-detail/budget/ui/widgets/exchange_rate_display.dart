import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/budget_constants.dart';

/// Widget hiển thị tỷ giá
class ExchangeRateDisplay extends StatelessWidget {
  const ExchangeRateDisplay({super.key});

  @override
  Widget build(final BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Tỷ giá tạm tính: 1 USD = ${formatter.format(BudgetConstants.exchangeRate.round())} đ',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
