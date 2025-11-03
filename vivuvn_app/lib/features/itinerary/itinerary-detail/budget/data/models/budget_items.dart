import 'dart:convert';

import '../../../member/data/model/member.dart';
import 'budget_type.dart';

/// Model đại diện cho một budget item (khoản chi tiêu)
///
/// Chứa:
/// - id: ID của item (nullable khi tạo mới)
/// - name: Tên khoản chi
/// - cost: Số tiền (VND)
/// - budgetType: Tên loại chi tiêu (string)
/// - budgetTypeObj: Object loại chi tiêu (nullable)
/// - date: Ngày chi tiêu
class BudgetItem {
  final int? id;
  final String name;
  final double cost;
  final String budgetType;
  final BudgetType? budgetTypeObj;
  final DateTime date;
  final Member? paidByMember;

  const BudgetItem({
    this.id,
    required this.name,
    required this.cost,
    required this.budgetType,
    this.budgetTypeObj,
    required this.date,
    this.paidByMember,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'name': name,
      'cost': cost,
      // prefer sending the id if we have a BudgetType object
      if (budgetTypeObj != null)
        'budgetType': budgetTypeObj!.budgetTypeId
      else
        'budgetType': budgetType,
      'date': date.toIso8601String(),
      if (paidByMember != null) 'memberId': paidByMember!.memberId,
    };
  }

  factory BudgetItem.fromMap(final Map<String, dynamic> map) {
    // parse date field: API may return ISO string or epoch millis
    final dateField = map['date'];
    DateTime parsedDate;
    if (dateField is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(dateField);
    } else if (dateField is String) {
      parsedDate = DateTime.tryParse(dateField) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    // budgetType may be provided as an id (int), a string name, or an object
    final btField = map['budgetType'];
    String btName;
    BudgetType? btObj;
    if (btField is int) {
      btName = btField.toString();
    } else if (btField is String) {
      btName = btField;
    } else if (btField is Map<String, dynamic>) {
      btObj = BudgetType.fromMap(btField);
      btName = btObj.name;
    } else {
      btName = '';
    }

    // Parse paidByMember if present
    Member? paidByMember;
    final paidByMemberField = map['paidByMember'];
    if (paidByMemberField != null && paidByMemberField is Map<String, dynamic>) {
      paidByMember = Member.fromMap(paidByMemberField);
    }

    return BudgetItem(
      id: map['id'] is int ? map['id'] as int : null,
      name: map['name'] as String,
      cost: (map['cost'] as num).toDouble(),
      budgetType: btName,
      budgetTypeObj: btObj,
      date: parsedDate,
      paidByMember: paidByMember,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetItem.fromJson(final String source) =>
      BudgetItem.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Create copy with updated fields
  BudgetItem copyWith({
    final int? id,
    final String? name,
    final double? cost,
    final String? budgetType,
    final BudgetType? budgetTypeObj,
    final DateTime? date,
    final Member? paidByMember,
  }) {
    return BudgetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      budgetType: budgetType ?? this.budgetType,
      budgetTypeObj: budgetTypeObj ?? this.budgetTypeObj,
      date: date ?? this.date,
      paidByMember: paidByMember ?? this.paidByMember,
    );
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is BudgetItem &&
        other.id == id &&
        other.name == name &&
        other.cost == cost &&
        other.budgetType == budgetType &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        cost.hashCode ^
        budgetType.hashCode ^
        date.hashCode;
  }

  @override
  String toString() =>
      'BudgetItem(id: $id, name: $name, cost: $cost, type: $budgetType)';

}
