import 'dart:convert';

/// DTO để cập nhật ngân sách dự kiến (estimated budget)
///
/// Required:
/// - itineraryId: ID của itinerary
/// - estimatedBudget: Ngân sách dự kiến mới (VND)
class UpdateBudgetRequest {
  final int itineraryId;
  final double estimatedBudget;

  const UpdateBudgetRequest({
    required this.itineraryId,
    required this.estimatedBudget,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'estimatedBudget': estimatedBudget};
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'UpdateBudgetRequest(itineraryId: $itineraryId, estimatedBudget: $estimatedBudget)';
}
