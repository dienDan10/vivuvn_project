import 'dart:convert';

/// DTO để tạo budget item mới
///
/// Required fields:
/// - itineraryId: ID của itinerary
/// - name: Tên khoản chi
/// - cost: Số tiền (VND)
/// - budgetTypeId: ID loại chi tiêu
/// - date: Ngày chi tiêu
class AddBudgetItemRequest {
  final int itineraryId;
  final String name;
  final double cost;
  final int budgetTypeId;
  final DateTime date;

  const AddBudgetItemRequest({
    required this.itineraryId,
    required this.name,
    required this.cost,
    required this.budgetTypeId,
    required this.date,
  });

  /// Convert to Map for API request
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'cost': cost,
      'budgetTypeId': budgetTypeId,
      'date': date.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'AddBudgetItemRequest(name: $name, cost: $cost, typeId: $budgetTypeId, date: ${date.toIso8601String()})';
}
