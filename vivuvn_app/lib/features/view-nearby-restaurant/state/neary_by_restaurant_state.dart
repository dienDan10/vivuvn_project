import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/restaurant.dart';

class NearbyRestaurantState {
  final bool isLoading;
  final String? errorMessage;
  final List<Restaurant> restaurants;
  final List<Marker> markers;
  final int currentRestaurantIndex;

  NearbyRestaurantState({
    this.isLoading = false,
    this.errorMessage,
    this.restaurants = const [],
    this.markers = const [],
    this.currentRestaurantIndex = 0,
  });

  NearbyRestaurantState copyWith({
    final bool? isLoading,
    final String? errorMessage,
    final List<Restaurant>? restaurants,
    final List<Marker>? markers,
    final int? currentRestaurantIndex,
  }) {
    return NearbyRestaurantState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      restaurants: restaurants ?? this.restaurants,
      markers: markers ?? this.markers,
      currentRestaurantIndex:
          currentRestaurantIndex ?? this.currentRestaurantIndex,
    );
  }
}
