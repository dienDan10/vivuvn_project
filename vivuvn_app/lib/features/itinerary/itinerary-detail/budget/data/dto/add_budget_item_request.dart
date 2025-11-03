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
  final int? payerMemberId;

  const AddBudgetItemRequest({
    required this.itineraryId,
    required this.name,
    required this.cost,
    required this.budgetTypeId,
    required this.date,
    this.payerMemberId,
  });

  /// Convert to Map for API request
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'cost': cost,
      'budgetTypeId': budgetTypeId,
      'date': date.toIso8601String(),
      // Always include memberId; explicit null signals no payer
      'memberId': payerMemberId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'AddBudgetItemRequest(name: $name, cost: $cost, typeId: $budgetTypeId, date: ${date.toIso8601String()})';
}
