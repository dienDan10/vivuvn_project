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

  /// Parse từ JSON (string -> TimeOfDay)
  factory ItineraryItem.fromJson(final Map<String, dynamic> json) {
    TimeOfDay? parseTime(final dynamic timeValue) {
      if (timeValue == null) return null;
      final timeString = timeValue.toString();

      // Xử lý chuỗi dạng "11:14:00" hoặc "11:14"
      final parts = timeString.split(':');
      if (parts.length < 2) return null;

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
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
      transportationDuration: json['transportationDuration'] as int?,
      transportationDistance: json['transportationDistance'] as int?,
    );
  }

  /// Convert sang JSON (TimeOfDay -> ISO string)
  Map<String, dynamic> toJson() {
    String? formatTime(final TimeOfDay? time) {
      if (time == null) return null;
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return dt.toIso8601String();
    }

    return {
      'itineraryItemId': itineraryItemId,
      'orderIndex': orderIndex,
      'location': location.toJson(),
      'note': note,
      'estimateDuration': estimateDuration,
      'startTime': formatTime(startTime),
      'endTime': formatTime(endTime),
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
    final TimeOfDay? startTime,
    final TimeOfDay? endTime,
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
