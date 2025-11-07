import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../itinerary-detail/schedule/model/location.dart';
import '../../../view-nearby-restaurant/service/icon_service.dart';
import '../../controller/hotel_controller.dart';
import '../../data/model/hotel.dart';

class MapHotel extends ConsumerStatefulWidget {
  final Location location;
  const MapHotel({super.key, required this.location});

  @override
  ConsumerState<MapHotel> createState() => _MapHotelState();
}

class _MapHotelState extends ConsumerState<MapHotel> {
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
      ref.read(hotelControllerProvider.notifier).fetchNearbyHotels(40);
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

    ref.read(hotelControllerProvider.notifier).addMarkers([
      Marker(
        markerId: MarkerId('location-${widget.location.id}'),
        position: LatLng(widget.location.latitude!, widget.location.longitude!),
        icon: locationIcon,
        infoWindow: InfoWindow(title: widget.location.name),
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
