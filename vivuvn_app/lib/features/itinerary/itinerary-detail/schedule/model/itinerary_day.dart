import 'itinerary_item.dart';

class ItineraryDay {
  final int id;
  final int dayNumber;
  final DateTime? date;
  final List<ItineraryItem> items;

  ItineraryDay({
    required this.id,
    required this.dayNumber,
    required this.date,
    required this.items,
  });

  factory ItineraryDay.fromJson(final Map<String, dynamic> json) {
    return ItineraryDay(
      id: json['id'] is int ? json['id'] as int : 0,
      dayNumber: json['dayNumber'] is int ? json['dayNumber'] as int : 0,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      items:
          (json['items'] as List?)
              ?.map((final e) => ItineraryItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}
