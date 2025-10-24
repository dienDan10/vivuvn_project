import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/restaurant_controller.dart';

class MapRestaurant extends ConsumerStatefulWidget {
  const MapRestaurant({super.key});

  @override
  ConsumerState<MapRestaurant> createState() => _MapRestaurantState();
}

class _MapRestaurantState extends ConsumerState<MapRestaurant> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(21.0235876, 105.8516497),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref
          .read(restaurantControllerProvider.notifier)
          .fetchNearbyRestaurants(40);
    });
  }

  @override
  Widget build(final BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      onMapCreated: (final GoogleMapController controller) {
        _controller.complete(controller);
      },
      zoomControlsEnabled: false,
    );
  }
}
