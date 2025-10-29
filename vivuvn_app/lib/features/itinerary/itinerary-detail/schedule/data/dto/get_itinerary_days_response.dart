import '../../model/itinerary_day.dart';

class GetItineraryDaysResponse {
  final List<ItineraryDay> days;

  GetItineraryDaysResponse({required this.days});

  factory GetItineraryDaysResponse.fromJson(final List<dynamic> json) {
    return GetItineraryDaysResponse(
      days: json.map((final e) => ItineraryDay.fromJson(e)).toList(),
    );
  }
}
