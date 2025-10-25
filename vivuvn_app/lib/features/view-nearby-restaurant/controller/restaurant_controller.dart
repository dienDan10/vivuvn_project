import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../model/restaurant.dart';
import '../service/icon_service.dart';
import '../service/restaurant_service.dart';
import '../state/neary_by_restaurant_state.dart';

class RestaurantController extends AutoDisposeNotifier<NearbyRestaurantState> {
  @override
  NearbyRestaurantState build() {
    return NearbyRestaurantState();
  }

  Future<void> fetchNearbyRestaurants(final int locationId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final restaurants = await ref
          .read(restaurantServiceProvider)
          .fetchNearbyRestaurants(locationId);

      state = state.copyWith(restaurants: restaurants);

      await _loadRestaurantMarkers(restaurants);
    } on DioException catch (e) {
      state = state.copyWith(
        errorMessage: DioExceptionHandler.handleException(e),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _loadRestaurantMarkers(
    final List<Restaurant> restaurants,
  ) async {
    final restaurantIcon = await ref
        .read(iconServiceProvider)
        .createCustomMarkerBitmap(
          'assets/icons/restaurant-marker.png',
          size: 30,
        );

    final restaurantMarkers = restaurants.map((final restaurant) {
      return Marker(
        markerId: MarkerId('restaurant-${restaurant.id}'),
        position: LatLng(restaurant.latitude!, restaurant.longitude!),
        icon: restaurantIcon,
        infoWindow: InfoWindow(title: restaurant.name),
      );
    }).toList();

    addMarkers(restaurantMarkers);
  }

  void addMarkers(final List<Marker> markers) {
    state = state.copyWith(markers: [...state.markers, ...markers]);
  }

  void setCurrentRestaurantIndex(final int index) {
    state = state.copyWith(currentRestaurantIndex: index);
  }
}

final restaurantControllerProvider =
    AutoDisposeNotifierProvider<RestaurantController, NearbyRestaurantState>(
      () => RestaurantController(),
    );
