import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../view-nearby-restaurant/service/icon_service.dart';
import '../../controller/hotel_controller.dart';
import '../../model/hotel.dart';

class MapHotel extends ConsumerStatefulWidget {
  const MapHotel({super.key});

  @override
  ConsumerState<MapHotel> createState() => _MapHotelState();
}

class _MapHotelState extends ConsumerState<MapHotel> {
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
      ref.read(hotelControllerProvider.notifier).fetchNearbyHotels(40);
    });

    // Load custom markers
    _loadLocationMarkers();
  }

  Future<void> _loadLocationMarkers() async {
    final BitmapDescriptor locationIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap('assets/icons/location-marker.png');

    ref.read(hotelControllerProvider.notifier).addMarkers([
      Marker(
        markerId: const MarkerId('location-40'),
        position: const LatLng(21.0235876, 105.8516497),
        icon: locationIcon,
      ),
    ]);
  }

  Future<void> _moveCameraToHotel(final Hotel hotel) async {
    final controller = await _controller.future;

    // move camera to the selected hotel
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(hotel.latitude!, hotel.longitude!),
          zoom: 16,
        ),
      ),
    );

    // Show info window
    await controller.showMarkerInfoWindow(MarkerId('hotel-${hotel.id}'));
  }

  @override
  Widget build(final BuildContext context) {
    final markers = ref.watch(
      hotelControllerProvider.select((final state) => state.markers),
    );

    ref.listen(
      hotelControllerProvider.select((final state) => state.currentHotelIndex),
      (final prev, final next) async {
        if (prev == next) return;
        final hotel = ref.read(
          hotelControllerProvider.select((final state) => state.hotels[next]),
        );

        await _moveCameraToHotel(hotel);
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
