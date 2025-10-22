import 'dart:convert';

class GenerateItineraryByAiRequest {
  final int itineraryId;
  final List<String>? preferences;
  final int groupSize;
  final double budget;
  final String? specialRequirements;

  GenerateItineraryByAiRequest({
    required this.itineraryId,
    this.preferences = const [],
    required this.groupSize,
    required this.budget,
    this.specialRequirements,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Preferences': preferences,
      'GroupSize': groupSize,
      // Server expects an integer (Int64) for Budget.
      'Budget': budget.round(),
      'SpecialRequirements': specialRequirements ?? '',
    };
  }

  String toJson() => json.encode(toMap());
}
