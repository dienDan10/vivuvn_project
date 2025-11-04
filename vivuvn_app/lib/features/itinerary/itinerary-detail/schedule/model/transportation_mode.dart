import 'package:flutter/material.dart';

/// Transportation modes for AI itinerary generation
class TransportationMode {
  static const String airplane = 'Máy bay';
  static const String bus = 'Xe khách';
  static const String train = 'Tàu hỏa';
  static const String privateCar = 'Ô tô cá nhân';
  static const String motorbike = 'Xe máy';

  /// All available transportation modes
  static const List<String> all = [
    airplane,
    bus,
    train,
    privateCar,
    motorbike,
  ];

  /// Get icon for transportation mode
  static IconData getIcon(final String mode) {
    switch (mode) {
      case airplane:
        return Icons.flight;
      case bus:
        return Icons.directions_bus;
      case train:
        return Icons.train;
      case privateCar:
        return Icons.directions_car;
      case motorbike:
        return Icons.two_wheeler;
      default:
        return Icons.directions;
    }
  }
}

