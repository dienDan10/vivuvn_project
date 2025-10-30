import '../data/dto/restaurant_item_response.dart';

class RestaurantsState {
  final bool isLoading;
  final List<RestaurantItemResponse> restaurants;
  final String? error;
  final int? itineraryId;
  final String? savingRestaurantId;
  final RestaurantSavingType? savingType;

  RestaurantsState({
    this.isLoading = false,
    this.restaurants = const [],
    this.error,
    this.itineraryId,
    this.savingRestaurantId,
    this.savingType,
  });

  RestaurantsState copyWith({
    final bool? isLoading,
    final List<RestaurantItemResponse>? restaurants,
    final String? error,
    final int? itineraryId,
    final String? savingRestaurantId,
    final RestaurantSavingType? savingType,
  }) {
    return RestaurantsState(
      isLoading: isLoading ?? this.isLoading,
      restaurants: restaurants ?? this.restaurants,
      error: error,
      itineraryId: itineraryId ?? this.itineraryId,
      savingRestaurantId: savingRestaurantId,
      savingType: savingType,
    );
  }

  bool isSaving(String restaurantId, RestaurantSavingType type) {
    return savingRestaurantId == restaurantId && savingType == type;
  }

  bool isAnySaving(String restaurantId) {
    return savingRestaurantId == restaurantId;
  }
}

enum RestaurantSavingType {
  cost,
  note,
  date,
  time,
}
