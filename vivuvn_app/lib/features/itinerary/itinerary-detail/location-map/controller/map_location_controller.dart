import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../view-nearby-restaurant/service/icon_service.dart';
import '../../detail/controller/itinerary_detail_controller.dart';
import '../../overview/data/dto/hotel_item_response.dart';
import '../../overview/data/dto/restaurant_item_response.dart';
import '../../overview/services/hotels_service.dart';
import '../../overview/services/restaurants_service.dart';
import '../../schedule/model/itinerary_day.dart';
import '../service/direction_service.dart';
import '../state/map_location_state.dart';
import '../ui/hotel_info_window.dart';
import '../ui/restaurant_info_window.dart';

class MapLocationController extends AutoDisposeNotifier<MapLocationState> {
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  @override
  MapLocationState build() {
    ref.onDispose(() {
      customInfoWindowController.dispose();
    });
    return MapLocationState(selectedDayIndex: 0, days: []);
  }

  void setDays(final List<ItineraryDay> days) {
    state = state.copyWith(days: days);
  }

  Future<void> loadHotelsAndRestaurants() async {
    final itineraryId = ref.read(itineraryDetailControllerProvider).itineraryId;
    if (itineraryId == null) return;
    final hotels = await ref.read(hotelsServiceProvider).getHotels(itineraryId);

    final restaurants = await ref
        .read(restaurantsServiceProvider)
        .getRestaurants(itineraryId);

    if (hotels.isNotEmpty) {
      state = state.copyWith(hotels: hotels);
    }

    if (restaurants.isNotEmpty) {
      state = state.copyWith(restaurants: restaurants);
    }

    // set marker for restaurants and hotels
    await setRestaurantsMarkers();
    await setHotelsMarkers();
  }

  Future<void> setSelectedIndex(final int index) async {
    if (index < 0 || index >= state.days.length) return;

    // Hide any open info windows when changing days
    if (customInfoWindowController.hideInfoWindow != null) {
      customInfoWindowController.hideInfoWindow!();
    }

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

    // add markers for restaurant with the same day
    await setRestaurantsMarkers();
    // add markers for hotel with the same day
    await setHotelsMarkers();
  }

  Future<void> setRestaurantsMarkers() async {
    if (state.restaurants.isEmpty) return;

    final selectedDay = state.days[state.selectedDayIndex];
    final markers = state.locationMarkers.toSet();
    final restaurantIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap(
          'assets/icons/restaurant-marker.png',
          size: 40,
        );

    // add markers for restaurant with the same day
    for (final restaurant in state.restaurants) {
      if (restaurant.mealDate == null) continue;
      if (restaurant.latitude == null || restaurant.longitude == null) continue;
      if (restaurant.mealDate!.year == selectedDay.date?.year &&
          restaurant.mealDate!.month == selectedDay.date?.month &&
          restaurant.mealDate!.day == selectedDay.date?.day) {
        final marker = Marker(
          markerId: MarkerId('restaurant-${restaurant.id}'),
          icon: restaurantIcon,
          position: LatLng(restaurant.latitude!, restaurant.longitude!),
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              _buildRestaurantInfoWindow(restaurant),
              LatLng(restaurant.latitude!, restaurant.longitude!),
            );
          },
        );
        markers.add(marker);
      }
    }

    state = state.copyWith(locationMarkers: markers.toList());
  }

  Widget _buildRestaurantInfoWindow(final RestaurantItemResponse restaurant) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0),
      child: RestaurantInfoWindow(restaurant: restaurant),
    );
  }

  Widget _buildHotelInfoWindow(final HotelItemResponse hotel) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0),
      child: HotelInfoWindow(hotel: hotel),
    );
  }

  Future<void> setHotelsMarkers() async {
    if (state.hotels.isEmpty) return;

    final selectedDay = state.days[state.selectedDayIndex];
    final markers = state.locationMarkers.toSet();
    final hotelIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap('assets/icons/hotel-marker.png', size: 40);

    // add markers for hotel with the same day
    for (final hotel in state.hotels) {
      if (hotel.checkInDate == null || hotel.checkOutDate == null) continue;
      if (hotel.latitude == null || hotel.longitude == null) continue;

      // Check if hotel stay overlaps with selected day
      if (hotel.checkInDate!.isBefore(
            selectedDay.date!.add(const Duration(days: 1)),
          ) &&
          hotel.checkOutDate!.isAfter(
            selectedDay.date!.subtract(const Duration(days: 1)),
          )) {
        final marker = Marker(
          markerId: MarkerId('hotel-${hotel.id}'),
          icon: hotelIcon,
          position: LatLng(hotel.latitude!, hotel.longitude!),
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              _buildHotelInfoWindow(hotel),
              LatLng(hotel.latitude!, hotel.longitude!),
            );
          },
        );
        markers.add(marker);
      }
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
