import 'dart:convert';

class BudgetType {
  final int budgetTypeId;
  final String name;

  BudgetType({required this.budgetTypeId, required this.name});

  Map<String, dynamic> toMap() => {'budgetTypeId': budgetTypeId, 'name': name};

  factory BudgetType.fromMap(final Map<String, dynamic> map) {
    return BudgetType(
      budgetTypeId: (map['budgetTypeId'] as num).toInt(),
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetType.fromJson(final String source) =>
      BudgetType.fromMap(json.decode(source) as Map<String, dynamic>);
}
