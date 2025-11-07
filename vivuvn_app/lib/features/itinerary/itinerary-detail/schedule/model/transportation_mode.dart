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

  /// Compare two transportation mode labels ignoring case.
  static bool equalsIgnoreCase(final String? a, final String? b) {
    if (a == null || b == null) return false;
    return a.trim().toLowerCase() == b.trim().toLowerCase();
  }

  /// Return the canonical label (matching the entries in [all])
  /// for the given [mode], comparing labels case-insensitively.
  /// If no match is found, the original value is returned.
  static String normalizeLabel(final String mode) {
    final lower = mode.trim().toLowerCase();
    return all.firstWhere(
      (final item) => item.toLowerCase() == lower,
      orElse: () => mode,
    );
  }

  /// Get icon for transportation mode
  static IconData getIcon(final String mode) {
    final normalizedMode = normalizeLabel(mode);
    switch (normalizedMode) {
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

