import '../model/restaurant.dart';

class NearbyRestaurantState {
  final bool isLoading;
  final String? errorMessage;
  final List<Restaurant> restaurants;

  NearbyRestaurantState({
    this.isLoading = false,
    this.errorMessage,
    this.restaurants = const [],
  });

  NearbyRestaurantState copyWith({
    final bool? isLoading,
    final String? errorMessage,
    final List<Restaurant>? restaurants,
  }) {
    return NearbyRestaurantState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      restaurants: restaurants ?? this.restaurants,
    );
  }
}
