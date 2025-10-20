import 'dart:convert';

class UpdateBudgetItemRequest {
  final int itineraryId;
  final int itemId;
  final String? name;
  final double? cost;
  final int? budgetTypeId;
  final String? budgetType;
  final DateTime? date;

  UpdateBudgetItemRequest({
    required this.itineraryId,
    required this.itemId,
    this.name,
    this.cost,
    this.budgetTypeId,
    this.budgetType,
    this.date,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      if (name != null) 'name': name,
      if (cost != null) 'cost': cost,
      if (budgetTypeId != null)
        'budgetType': budgetTypeId
      else if (budgetType != null)
        'budgetType': budgetType,
      if (date != null) 'date': date!.toIso8601String(),
    };

    // Validate before returning map to avoid sending empty bodies
    if (map.isEmpty) {
      throw ArgumentError(
        'Update request must contain at least one field to update',
      );
    }
    return map;
  }

  String toJson() => json.encode(toMap());
}
