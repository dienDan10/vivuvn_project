import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/map_location_controller.dart';
import '../data/modal/directions.dart';

class MapLocation extends ConsumerStatefulWidget {
  const MapLocation({super.key});

  @override
  ConsumerState<MapLocation> createState() => _MapLocationState();
}

class _MapLocationState extends ConsumerState<MapLocation> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    // load route
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(mapLocationControllerProvider.notifier).loadRoutes();

      // Fit bounds after routes are loaded
      final controller = await _controller.future;
      await ref
          .read(mapLocationControllerProvider.notifier)
          .animateCameraToFitBounds(controller);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final locationMarkers = ref.watch(
      mapLocationControllerProvider.select(
        (final state) => state.locationMarkers,
      ),
    );

    final List<Directions> directions = ref.watch(
      mapLocationControllerProvider.select((final state) => state.directions),
    );

    // Generate polylines from directions
    final Set<Polyline> polylines = {};
    for (int i = 0; i < directions.length; i++) {
      final polyline = Polyline(
        polylineId: PolylineId('route_$i'),
        points: directions[i].polylinePoints,
        color: Colors.blue,
        width: 5,
      );
      polylines.add(polyline);
    }

    return GoogleMap(
      onMapCreated: (final GoogleMapController controller) {
        _controller.complete(controller);
      },
      initialCameraPosition: ref
          .read(mapLocationControllerProvider.notifier)
          .getInitialCameraPosition(),
      markers: Set.of(locationMarkers),
      polylines: polylines,
      myLocationButtonEnabled: false,
    );
  }
}
