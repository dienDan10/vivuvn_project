import 'dart:convert';

class AddBudgetItemRequest {
  final int itineraryId;
  final String name;
  final double cost;
  final int budgetTypeId;
  final DateTime date;

  AddBudgetItemRequest({
    required this.itineraryId,
    required this.name,
    required this.cost,
    required this.budgetTypeId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'cost': cost,
      'budgetTypeId': budgetTypeId,
      'date': date.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());
}
