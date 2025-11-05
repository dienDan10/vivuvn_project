import 'dart:convert';

import 'budget_items.dart';

/// Model đại diện cho Budget của một itinerary
///
/// Chứa:
/// - budgetId: ID của budget
/// - totalBudget: Tổng chi tiêu thực tế
/// - estimatedBudget: Ngân sách dự kiến
/// - items: Danh sách các budget items
class Budget {
  final int budgetId;
  final double totalBudget;
  final double estimatedBudget;
  final List<BudgetItem> items;

  const Budget({
    required this.budgetId,
    required this.totalBudget,
    required this.estimatedBudget,
    required this.items,
  });

  /// Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'budgetId': budgetId,
      'totalBudget': totalBudget,
      'estimatedBudget': estimatedBudget,
      'items': items.map((final e) => e.toMap()).toList(),
    };
  }

  /// Create from Map (JSON deserialization)
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

  /// Create copy with updated fields
  Budget copyWith({
    final int? budgetId,
    final double? totalBudget,
    final double? estimatedBudget,
    final List<BudgetItem>? items,
  }) {
    return Budget(
      budgetId: budgetId ?? this.budgetId,
      totalBudget: totalBudget ?? this.totalBudget,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is Budget &&
        other.budgetId == budgetId &&
        other.totalBudget == totalBudget &&
        other.estimatedBudget == estimatedBudget;
  }

  @override
  int get hashCode {
    return budgetId.hashCode ^ totalBudget.hashCode ^ estimatedBudget.hashCode;
  }

  @override
  String toString() =>
      'Budget(id: $budgetId, total: $totalBudget, estimated: $estimatedBudget, items: ${items.length})';
}
