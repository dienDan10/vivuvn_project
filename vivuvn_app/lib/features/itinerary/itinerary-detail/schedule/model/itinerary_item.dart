import 'package:flutter/material.dart';

import 'location.dart';

class ItineraryItem {
  final int itineraryItemId;
  final int orderIndex;
  final Location location;
  final String? note;
  final int? estimateDuration;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? transportationVehicle;
  final double? transportationDuration;
  final double? transportationDistance;

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
    TimeOfDay? parseTime(final dynamic timeValue) {
      if (timeValue == null) return null;
      final parts = timeValue.toString().split(':');
      if (parts.length < 2) return null;
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    return ItineraryItem(
      itineraryItemId: json['itineraryItemId'] as int,
      orderIndex: json['orderIndex'] ?? 0,
      location: Location.fromJson(json['location']),
      note: json['note'] as String?,
      estimateDuration: json['estimateDuration'] as int?,
      startTime: parseTime(json['startTime']),
      endTime: parseTime(json['endTime']),
      transportationVehicle: json['transportationVehicle'] as String?,
      transportationDuration: (json['transportationDuration'] as num?)
          ?.toDouble(),
      transportationDistance: (json['transportationDistance'] as num?)
          ?.toDouble(),
    );
  }

  ItineraryItem copyWith({
    final int? itineraryItemId,
    final int? orderIndex,
    final Location? location,
    final String? note,
    final int? estimateDuration,
    final TimeOfDay? startTime,
    final TimeOfDay? endTime,
    final String? transportationVehicle,
    final double? transportationDuration,
    final double? transportationDistance,
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
