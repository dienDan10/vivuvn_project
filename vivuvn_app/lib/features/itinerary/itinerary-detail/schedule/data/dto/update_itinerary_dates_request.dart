class UpdateItineraryDatesRequest {
  final DateTime startDate;
  final DateTime endDate;

  UpdateItineraryDatesRequest({required this.startDate, required this.endDate});

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
  };
}
