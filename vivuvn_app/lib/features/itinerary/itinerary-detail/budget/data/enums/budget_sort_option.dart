import 'package:flutter/material.dart';

enum BudgetSortOption {
  dateNewest('Ngày (mới nhất)', Icons.calendar_today),
  dateOldest('Ngày (xa nhất)', Icons.calendar_month),
  amountHighest('Giá (cao nhất)', Icons.arrow_downward),
  amountLowest('Giá (thấp nhất)', Icons.arrow_upward),
  typeAZ('Loại chi phí (A-Z)', Icons.category);

  final String label;
  final IconData icon;
  const BudgetSortOption(this.label, this.icon);
}
