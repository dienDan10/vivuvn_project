import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/modal/directions.dart';
import 'idirection_service.dart';

final directionServiceProvider = AutoDisposeProvider(
  (final ref) => DirectionService(),
);

class DirectionService implements IDirectionService {
  final String _apiKey;

  DirectionService() : _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  @override
  Future<Directions?> getDirections({
    required final LatLng origin,
    required final LatLng destination,
  }) async {
    final PolylinePoints polylinePoints = PolylinePoints(apiKey: _apiKey);

    // Create Route api request
    final RoutesApiRequest request = RoutesApiRequest(
      origin: PointLatLng(origin.latitude, origin.longitude),
      destination: PointLatLng(destination.latitude, destination.longitude),
      //travelMode: TravelMode.driving,
      languageCode: 'vi',
      routingPreference: RoutingPreference.trafficAware,
    );

    // Get the route using Routes Api
    final RoutesApiResponse response = await polylinePoints
        .getRouteBetweenCoordinatesV2(request: request);

    if (response.routes.isNotEmpty) {
      return Directions.fromRoute(response.routes.first);
    }

    return null;
  }

  @override
  Future<List<Directions>> getMultipleDirections({
    required final List<LatLng> locations,
  }) async {
    if (locations.length < 2) return [];

    final List<Directions> directions = [];

    for (int i = 0; i < locations.length - 1; i++) {
      final direction = await getDirections(
        origin: locations[i],
        destination: locations[i + 1],
      );

      if (direction != null) {
        directions.add(direction);
      }
    }

    return directions;
  }
}
