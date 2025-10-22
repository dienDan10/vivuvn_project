import 'dart:convert';

class GenerateItineraryByAiRequest {
  final List<String> preferences;
  final int groupSize;
  final double budget;
  final String? specialRequirements;

  GenerateItineraryByAiRequest({
    this.preferences = const [],
    required this.groupSize,
    required this.budget,
    this.specialRequirements,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'preferences': preferences,
      'group_size': groupSize,
      'budget': budget,
      'special_requirements': specialRequirements ?? '',
    };
  }

  String toJson() => json.encode(toMap());
}
