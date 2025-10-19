import 'location.dart';

class ItineraryItem {
  final int itineraryItemId;
  final Location? location;
  final int orderIndex;
  final String? note;
  final String? transportationVehicle;
  final int? transportationDuration;
  final int? transportationDistance;

  ItineraryItem({
    required this.itineraryItemId,
    this.location,
    required this.orderIndex,
    this.note,
    this.transportationVehicle,
    this.transportationDuration,
    this.transportationDistance,
  });

  factory ItineraryItem.fromJson(final Map<String, dynamic> json) {
    return ItineraryItem(
      itineraryItemId: json['itineraryItemId'] is int
          ? json['itineraryItemId']
          : 0,
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      orderIndex: json['orderIndex'] is int ? json['orderIndex'] : 0,
      note: json['note']?.toString(),
      transportationVehicle: json['transportationVehicle']?.toString(),
      transportationDuration: json['transportationDuration'] is int
          ? json['transportationDuration']
          : null,
      transportationDistance: json['transportationDistance'] is int
          ? json['transportationDistance']
          : null,
    );
  }
}
