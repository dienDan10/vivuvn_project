import '../data/dto/restaurant_item_response.dart';

class RestaurantsState {
  final bool isLoading;
  final List<RestaurantItemResponse> restaurants;
  final String? error;
  final int? itineraryId;

  RestaurantsState({
    this.isLoading = false,
    this.restaurants = const [],
    this.error,
    this.itineraryId,
  });

  RestaurantsState copyWith({
    final bool? isLoading,
    final List<RestaurantItemResponse>? restaurants,
    final String? error,
    final int? itineraryId,
  }) {
    return RestaurantsState(
      isLoading: isLoading ?? this.isLoading,
      restaurants: restaurants ?? this.restaurants,
      error: error,
      itineraryId: itineraryId ?? this.itineraryId,
    );
  }
}
