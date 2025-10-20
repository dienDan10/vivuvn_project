import 'dart:convert';

class UpdateBudgetRequest {
  final int itineraryId;
  final double estimatedBudget;

  UpdateBudgetRequest({
    required this.itineraryId,
    required this.estimatedBudget,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'estimatedBudget': estimatedBudget};
  }

  String toJson() => json.encode(toMap());
}
