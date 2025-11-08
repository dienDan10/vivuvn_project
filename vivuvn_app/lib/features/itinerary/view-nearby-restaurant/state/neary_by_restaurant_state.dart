import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/model/restaurant.dart';

class NearbyRestaurantState {
  final bool isLoading;
  final String? errorMessage;
  final List<Restaurant> restaurants;
  final List<Marker> markers;
  final int currentRestaurantIndex;
  final bool isAddingToItinerary;
  final String? addToItineraryErrorMessage;

  NearbyRestaurantState({
    this.isLoading = false,
    this.errorMessage,
    this.restaurants = const [],
    this.markers = const [],
    this.currentRestaurantIndex = 0,
    this.isAddingToItinerary = false,
    this.addToItineraryErrorMessage,
  });

  NearbyRestaurantState copyWith({
    final bool? isLoading,
    final String? errorMessage,
    final List<Restaurant>? restaurants,
    final List<Marker>? markers,
    final int? currentRestaurantIndex,
    final bool? isAddingToItinerary,
    final String? addToItineraryErrorMessage,
  }) {
    return NearbyRestaurantState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      restaurants: restaurants ?? this.restaurants,
      markers: markers ?? this.markers,
      currentRestaurantIndex:
          currentRestaurantIndex ?? this.currentRestaurantIndex,
      isAddingToItinerary: isAddingToItinerary ?? this.isAddingToItinerary,
      addToItineraryErrorMessage:
          addToItineraryErrorMessage ?? this.addToItineraryErrorMessage,
    );
  }
}
