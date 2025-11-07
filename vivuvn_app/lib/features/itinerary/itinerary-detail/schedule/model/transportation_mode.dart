import 'package:flutter/material.dart';

/// Transportation modes for AI itinerary generation
class TransportationMode {
  static const String airplane = 'Máy bay';
  static const String bus = 'Xe khách';
  static const String train = 'Tàu hỏa';
  static const String privateCar = 'Ô tô cá nhân';
  static const String motorbike = 'Xe máy';

  static const Map<String, String> _vietnameseToEnglish = {
    airplane: 'Airplane',
    bus: 'Bus',
    train: 'Train',
    privateCar: 'PrivateCar',
    motorbike: 'Motorbike',
  };

  static final Map<String, String> _englishToVietnamese = {
    'airplane': airplane,
    'plane': airplane,
    'flight': airplane,
    'bus': bus,
    'coach': bus,
    'train': train,
    'rail': train,
    'privatecar': privateCar,
    'private car': privateCar,
    'car': privateCar,
    'drive': privateCar,
    'motorbike': motorbike,
    'motor bike': motorbike,
    'motorcycle': motorbike,
    'bike': motorbike,
  };

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
    return normalizeLabel(a) == normalizeLabel(b);
  }

  /// Return the canonical label (matching the entries in [all])
  /// for the given [mode], comparing labels case-insensitively.
  /// If no match is found, the original value is returned.
  static String normalizeLabel(final String mode) {
    final trimmed = mode.trim();
    if (trimmed.isEmpty) return trimmed;

    final lower = trimmed.toLowerCase();

    for (final item in all) {
      if (item.toLowerCase() == lower) {
        return item;
      }
    }

    final mapped = _englishToVietnamese[lower];
    if (mapped != null) {
      return mapped;
    }

    return trimmed;
  }

  static String toApiValue(final String mode) {
    final normalized = normalizeLabel(mode);
    final apiValue = _vietnameseToEnglish[normalized];
    if (apiValue != null) {
      return apiValue;
    }
    return normalized;
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

