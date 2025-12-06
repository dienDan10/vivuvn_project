import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final double durationMinutes;

  Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.distanceKm,
    required this.durationMinutes,
  });

  factory Directions.fromRoute(final Route route) {
    List<LatLng> latLngPoints = [];
    LatLngBounds? bounds;
    if (route.polylinePoints != null) {
      latLngPoints = route.polylinePoints!
          .map((final e) => LatLng(e.latitude, e.longitude))
          .toList();
    }

    if (latLngPoints.isNotEmpty) {
      double south = latLngPoints.first.latitude;
      double north = latLngPoints.first.latitude;
      double west = latLngPoints.first.longitude;
      double east = latLngPoints.first.longitude;

      for (final point in latLngPoints) {
        if (point.latitude < south) south = point.latitude;
        if (point.latitude > north) north = point.latitude;
        if (point.longitude < west) west = point.longitude;
        if (point.longitude > east) east = point.longitude;
      }

      bounds = LatLngBounds(
        southwest: LatLng(south, west),
        northeast: LatLng(north, east),
      );
    } else {
      // Default to a small bounds around origin if no points
      bounds = LatLngBounds(
        southwest: const LatLng(0, 0),
        northeast: const LatLng(0, 0),
      );
    }

    return Directions(
      bounds: bounds,
      polylinePoints: latLngPoints,
      distanceKm: route.distanceKm ?? 0.0,
      durationMinutes: route.durationMinutes ?? 0.0,
    );
  }
}
