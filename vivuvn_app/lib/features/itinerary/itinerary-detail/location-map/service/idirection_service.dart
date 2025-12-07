import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/modal/directions.dart';

abstract interface class IDirectionService {
  Future<Directions?> getDirections({
    required final LatLng origin,
    required final LatLng destination,
    final List<LatLng>? intermediates,
  });

  Future<Directions?> getRouteWithMultipleStops({
    required final List<LatLng> locations,
  });
}
