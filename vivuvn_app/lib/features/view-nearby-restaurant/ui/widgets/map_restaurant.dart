import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/restaurant_controller.dart';
import '../../model/restaurant.dart';
import '../../service/icon_service.dart';

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

    // Fetch nearby restaurants after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref
          .read(restaurantControllerProvider.notifier)
          .fetchNearbyRestaurants(40);
    });

    // Load custom markers
    _loadLocationMarkers();
  }

  Future<void> _loadLocationMarkers() async {
    final BitmapDescriptor locationIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap('assets/icons/location-marker.png');

    ref.read(restaurantControllerProvider.notifier).addMarkers([
      Marker(
        markerId: const MarkerId('location-40'),
        position: const LatLng(21.0235876, 105.8516497),
        icon: locationIcon,
      ),
    ]);
  }

  Future<void> _moveCameraToRestaurant(final Restaurant restaurant) async {
    final controller = await _controller.future;

    // move camera to the selected restaurant
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(restaurant.latitude!, restaurant.longitude!),
          zoom: 16,
        ),
      ),
    );

    // Show info window
    await controller.showMarkerInfoWindow(
      MarkerId('restaurant-${restaurant.id}'),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final markers = ref.watch(
      restaurantControllerProvider.select((final state) => state.markers),
    );

    ref.listen(
      restaurantControllerProvider.select(
        (final state) => state.currentRestaurantIndex,
      ),
      (final prev, final next) async {
        if (prev == next) return;
        final restaurant = ref.read(
          restaurantControllerProvider.select(
            (final state) => state.restaurants[next],
          ),
        );

        await _moveCameraToRestaurant(restaurant);
      },
    );

    return GoogleMap(
      initialCameraPosition: _initialPosition,
      onMapCreated: (final GoogleMapController controller) {
        _controller.complete(controller);
      },
      zoomControlsEnabled: false,
      markers: Set<Marker>.of(markers),
    );
  }
}
