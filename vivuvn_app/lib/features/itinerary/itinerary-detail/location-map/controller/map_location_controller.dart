import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../view-nearby-restaurant/service/icon_service.dart';
import '../../schedule/model/itinerary_day.dart';
import '../service/direction_service.dart';
import '../state/map_location_state.dart';

class MapLocationController extends AutoDisposeNotifier<MapLocationState> {
  @override
  MapLocationState build() {
    return MapLocationState(selectedDayIndex: 0, days: []);
  }

  Future<void> setDays(final List<ItineraryDay> days) async {
    state = state.copyWith(days: days);
  }

  Future<void> setSelectedIndex(final int index) async {
    if (index < 0 || index >= state.days.length) return;

    state = state.copyWith(
      selectedDayIndex: index,
      currentItemIndex: 0,
      directions: [],
    );
    await setLocationMarkersForSelectedDay();
  }

  Future<void> setCurrentItemIndex(final int index) async {
    state = state.copyWith(currentItemIndex: index);
  }

  List<DateTime> getDayDates() {
    return state.days.map((final day) => day.date ?? DateTime.now()).toList();
  }

  CameraPosition getInitialCameraPosition() {
    final day = state.days[state.selectedDayIndex];
    return CameraPosition(
      target: LatLng(
        day.items.isNotEmpty ? day.items.first.location.latitude! : 0.0,
        day.items.isNotEmpty ? day.items.first.location.longitude! : 0.0,
      ),
      zoom: 14,
    );
  }

  Future<void> setLocationMarkersForSelectedDay() async {
    final selectedDay = state.days[state.selectedDayIndex];
    final markers = <Marker>{};
    final locationIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap('assets/icons/location-marker.png', size: 40);

    for (final item in selectedDay.items) {
      final marker = Marker(
        markerId: MarkerId('location-${item.location.id}'),
        icon: locationIcon,
        position: LatLng(item.location.latitude!, item.location.longitude!),
        infoWindow: InfoWindow(title: item.location.name),
        onTap: () {
          final index = selectedDay.items.indexOf(item);
          setCurrentItemIndex(index);
        },
      );
      markers.add(marker);
    }

    state = state.copyWith(locationMarkers: markers.toList());
  }

  Future<void> loadRoutes() async {
    final selectedDay = state.days[state.selectedDayIndex];
    if (selectedDay.items.length < 2) {
      return;
    }

    // Extract locations from items
    final locations = selectedDay.items
        .map(
          (final item) =>
              LatLng(item.location.latitude!, item.location.longitude!),
        )
        .toList();

    // Get single route through all locations
    final direction = await ref
        .read(directionServiceProvider)
        .getRouteWithMultipleStops(locations: locations);

    if (direction != null) {
      state = state.copyWith(directions: [direction]);
    }
  }

  Future<void> animateCameraToFitBounds(
    final GoogleMapController controller,
  ) async {
    final selectedDay = state.days[state.selectedDayIndex];
    // Handle single location or no directions
    if (state.directions.isEmpty) {
      if (selectedDay.items.isNotEmpty) {
        // Zoom to the single location
        final location = selectedDay.items.first.location;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude!, location.longitude!),
              zoom: 15,
            ),
          ),
        );
      }
      return;
    }

    // Collect all bounds from all directions
    double south = double.infinity;
    double north = -double.infinity;
    double west = double.infinity;
    double east = -double.infinity;

    for (final direction in state.directions) {
      if (direction.bounds.southwest.latitude < south) {
        south = direction.bounds.southwest.latitude;
      }
      if (direction.bounds.northeast.latitude > north) {
        north = direction.bounds.northeast.latitude;
      }
      if (direction.bounds.southwest.longitude < west) {
        west = direction.bounds.southwest.longitude;
      }
      if (direction.bounds.northeast.longitude > east) {
        east = direction.bounds.northeast.longitude;
      }
    }

    final bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    ); // 50 is padding
  }
}

final mapLocationControllerProvider =
    AutoDisposeNotifierProvider<MapLocationController, MapLocationState>(
      MapLocationController.new,
    );
