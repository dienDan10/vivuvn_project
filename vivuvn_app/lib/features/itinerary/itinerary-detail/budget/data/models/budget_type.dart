import 'dart:convert';

/// Model đại diện cho loại chi tiêu (Budget Type)
///
/// Chứa:
/// - budgetTypeId: ID của loại chi tiêu
/// - name: Tên loại chi tiêu (Ăn uống, Di chuyển, Lưu trú, ...)
class BudgetType {
  final int budgetTypeId;
  final String name;

  const BudgetType({required this.budgetTypeId, required this.name});

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

  BudgetType copyWith({final int? budgetTypeId, final String? name}) {
    return BudgetType(
      budgetTypeId: budgetTypeId ?? this.budgetTypeId,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is BudgetType &&
        other.budgetTypeId == budgetTypeId &&
        other.name == name;
  }

  @override
  int get hashCode => budgetTypeId.hashCode ^ name.hashCode;

  @override
  String toString() => 'BudgetType(id: $budgetTypeId, name: $name)';
}
