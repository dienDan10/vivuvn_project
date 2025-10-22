import 'dart:convert';

class GenerateItineraryByAiResponse {
  final Map<String, dynamic> raw;

  GenerateItineraryByAiResponse(this.raw);

  factory GenerateItineraryByAiResponse.fromJson(
    final Map<String, dynamic> json,
  ) {
    return GenerateItineraryByAiResponse(Map<String, dynamic>.from(json));
  }

  static GenerateItineraryByAiResponse fromDynamic(final dynamic data) {
    if (data == null) return GenerateItineraryByAiResponse(<String, dynamic>{});
    if (data is Map<String, dynamic>) {
      return GenerateItineraryByAiResponse.fromJson(data);
    }
    try {
      final parsed = json.decode(data as String);
      if (parsed is Map<String, dynamic>) {
        return GenerateItineraryByAiResponse.fromJson(parsed);
      }
    } catch (_) {
      // ignore
    }
    return GenerateItineraryByAiResponse(<String, dynamic>{});
  }
}
