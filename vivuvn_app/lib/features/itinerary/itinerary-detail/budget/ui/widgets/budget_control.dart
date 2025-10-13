import 'package:flutter/material.dart';

class BudgetControl extends StatelessWidget {
  const BudgetControl({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Các chi phí',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Row(
            children: [
              Text('sắp xếp: Ngày (mới nhất)'),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ],
      ),
    );
  }
}
