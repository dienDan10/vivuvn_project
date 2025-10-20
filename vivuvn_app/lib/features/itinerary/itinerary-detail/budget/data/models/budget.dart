import 'dart:convert';

import 'budget_items.dart';

class Budget {
  final int budgetId;
  final double totalBudget;
  final double estimatedBudget;
  final List<BudgetItem> items;

  Budget({
    required this.budgetId,
    required this.totalBudget,
    required this.estimatedBudget,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'budgetId': budgetId,
      'totalBudget': totalBudget,
      'estimatedBudget': estimatedBudget,
      'items': items.map((final e) => e.toMap()).toList(),
    };
  }

  factory Budget.fromMap(final Map<String, dynamic> map) {
    return Budget(
      budgetId: (map['budgetId'] as num).toInt(),
      totalBudget: (map['totalBudget'] as num).toDouble(),
      estimatedBudget: (map['estimatedBudget'] as num).toDouble(),
      items: (map['items'] as List<dynamic>)
          .map((final e) => BudgetItem.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Budget.fromJson(final String source) =>
      Budget.fromMap(json.decode(source) as Map<String, dynamic>);
}
