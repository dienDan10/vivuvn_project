class GenerateItineraryByAiResponse {
  final String status;
  final String message;
  final int itineraryId;
  final List<String> warnings;

  GenerateItineraryByAiResponse({
    required this.status,
    required this.message,
    required this.itineraryId,
    required this.warnings,
  });

  factory GenerateItineraryByAiResponse.fromJson(final Map<String, dynamic> json) {
    return GenerateItineraryByAiResponse(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      itineraryId: json['itineraryId'] as int? ?? 0,
      warnings: (json['warnings'] as List<dynamic>?)
          ?.map((final e) => e as String)
          .toList() ?? [],
    );
  }
}

