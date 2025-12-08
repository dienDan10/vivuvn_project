import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../schedule/model/location.dart';
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
      await _initializeMap();
    });
  }

  Future<void> _initializeMap() async {
    await ref.read(mapLocationControllerProvider.notifier).loadRoutes();

    final controller = await _controller.future;

    final day = ref.read(
      mapLocationControllerProvider.select(
        (final state) =>
            state.days.isNotEmpty ? state.days[state.selectedDayIndex] : null,
      ),
    );

    // If no items, don't do anything
    if (day == null || day.items.isEmpty) {
      return;
    }

    // Fit bounds after routes are loaded
    await ref
        .read(mapLocationControllerProvider.notifier)
        .animateCameraToFitBounds(controller);

    final firstLocation = day.items.first.location;
    // show info window for the first location

    // Wait a bit for markers to be fully rendered on the map
    await Future.delayed(const Duration(milliseconds: 100));
    controller.showMarkerInfoWindow(MarkerId('location-${firstLocation.id}'));
  }

  Future<void> _moveCameraToLocation(
    final Location location,
    final int index,
  ) async {
    final controller = await _controller.future;

    // move camera to the selected location
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude!, location.longitude!),
          zoom: 16,
        ),
      ),
    );

    // Show info window
    controller.showMarkerInfoWindow(MarkerId('location-${location.id}'));
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
        color: Theme.of(context).colorScheme.primary,
        width: 5,
      );
      polylines.add(polyline);
    }

    ref.listen(
      mapLocationControllerProvider.select(
        (final state) => state.selectedDayIndex,
      ),
      (final prev, final next) {
        if (prev != next) {
          _initializeMap();
        }
      },
    );

    ref.listen(
      mapLocationControllerProvider.select(
        (final state) => state.currentItemIndex,
      ),
      (final prev, final next) async {
        if (prev == next) return;
        final selectedDayIndex = ref.read(
          mapLocationControllerProvider.select(
            (final state) => state.selectedDayIndex,
          ),
        );
        final selectedDay = ref.read(
          mapLocationControllerProvider.select(
            (final state) =>
                state.days.isNotEmpty ? state.days[selectedDayIndex] : null,
          ),
        );
        final items = selectedDay?.items ?? [];
        if (next < 0 || next >= items.length) return;
        final item = items[next];
        await _moveCameraToLocation(item.location, item.orderIndex);
      },
    );

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (final GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: ref
              .read(mapLocationControllerProvider.notifier)
              .getInitialCameraPosition(),
          markers: Set.of(locationMarkers),
          polylines: polylines,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ],
    );
  }
}
