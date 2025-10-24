import 'location.dart';

class ItineraryItem {
  final int itineraryItemId;
  final int orderIndex;
  final Location location;
  final String? note;
  final int? estimateDuration;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? transportationVehicle;
  final int? transportationDuration;
  final int? transportationDistance;

  ItineraryItem({
    required this.itineraryItemId,
    required this.orderIndex,
    required this.location,
    this.note,
    this.estimateDuration,
    this.startTime,
    this.endTime,
    this.transportationVehicle,
    this.transportationDuration,
    this.transportationDistance,
  });

  factory ItineraryItem.fromJson(final Map<String, dynamic> json) {
    return ItineraryItem(
      itineraryItemId: json['itineraryItemId'] as int,
      orderIndex: json['orderIndex'] ?? 0,
      location: Location.fromJson(json['location']),
      note: json['note'] as String?,
      estimateDuration: json['estimateDuration'] as int?,
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'])
          : null,
      transportationVehicle: json['transportationVehicle'] as String?,
      transportationDuration: json['transportationDuration'] as int?,
      transportationDistance: json['transportationDistance'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itineraryItemId': itineraryItemId,
      'orderIndex': orderIndex,
      'location': location.toJson(),
      'note': note,
      'estimateDuration': estimateDuration,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'transportationVehicle': transportationVehicle,
      'transportationDuration': transportationDuration,
      'transportationDistance': transportationDistance,
    };
  }

  ItineraryItem copyWith({
    final int? itineraryItemId,
    final int? orderIndex,
    final Location? location,
    final String? note,
    final int? estimateDuration,
    final DateTime? startTime,
    final DateTime? endTime,
    final String? transportationVehicle,
    final int? transportationDuration,
    final int? transportationDistance,
  }) {
    return ItineraryItem(
      itineraryItemId: itineraryItemId ?? this.itineraryItemId,
      orderIndex: orderIndex ?? this.orderIndex,
      location: location ?? this.location,
      note: note ?? this.note,
      estimateDuration: estimateDuration ?? this.estimateDuration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      transportationVehicle:
          transportationVehicle ?? this.transportationVehicle,
      transportationDuration:
          transportationDuration ?? this.transportationDuration,
      transportationDistance:
          transportationDistance ?? this.transportationDistance,
    );
  }
}
