import 'dart:convert';

/// DTO để cập nhật budget item
///
/// Required:
/// - itineraryId: ID của itinerary
/// - itemId: ID của budget item cần update
///
/// Optional (ít nhất 1 field):
/// - name: Tên mới
/// - cost: Số tiền mới
/// - budgetTypeId: ID loại chi tiêu mới
/// - budgetType: Tên loại chi tiêu (fallback)
/// - date: Ngày mới
class UpdateBudgetItemRequest {
  final int itineraryId;
  final int itemId;
  final String? name;
  final double? cost;
  final int? budgetTypeId;
  final String? budgetType;
  final DateTime? date;

  const UpdateBudgetItemRequest({
    required this.itineraryId,
    required this.itemId,
    this.name,
    this.cost,
    this.budgetTypeId,
    this.budgetType,
    this.date,
  });

  /// Convert to Map, only include non-null fields
  ///
  /// Throws ArgumentError nếu không có field nào được update
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      if (name != null) 'name': name,
      if (cost != null) 'cost': cost,
      if (budgetTypeId != null)
        'budgetTypeId': budgetTypeId
      else if (budgetType != null)
        'budgetType': budgetType,
      if (date != null) 'date': date!.toIso8601String(),
    };

    if (map.isEmpty) {
      throw ArgumentError(
        'Update request must contain at least one field to update',
      );
    }
    return map;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'UpdateBudgetItemRequest(itemId: $itemId, name: $name, cost: $cost, typeId: $budgetTypeId)';
}
