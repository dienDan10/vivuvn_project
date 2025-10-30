import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../itinerary-detail/schedule/model/location.dart';
import '../../controller/restaurant_controller.dart';
import '../../model/restaurant.dart';
import '../../service/icon_service.dart';

class MapRestaurant extends ConsumerStatefulWidget {
  final Location location;
  const MapRestaurant({super.key, required this.location});

  @override
  ConsumerState<MapRestaurant> createState() => _MapRestaurantState();
}

class _MapRestaurantState extends ConsumerState<MapRestaurant> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target: LatLng(widget.location.latitude!, widget.location.longitude!),
      zoom: 14,
    );

    // Fetch nearby restaurants after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref
          .read(restaurantControllerProvider.notifier)
          .fetchNearbyRestaurants(widget.location.id);
    });

    // Load custom markers
    _loadLocationMarkers();

    // show info window for location marker after map is created
    WidgetsBinding.instance.addPostFrameCallback((final _) async {
      final controller = await _controller.future;
      await controller.showMarkerInfoWindow(
        MarkerId('location-${widget.location.id}'),
      );
    });
  }

  Future<void> _loadLocationMarkers() async {
    final BitmapDescriptor locationIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap('assets/icons/location-marker.png');

    ref.read(restaurantControllerProvider.notifier).addMarkers([
      Marker(
        markerId: MarkerId('location-${widget.location.id}'),
        position: LatLng(widget.location.latitude!, widget.location.longitude!),
        icon: locationIcon,
        infoWindow: InfoWindow(title: widget.location.name),
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
