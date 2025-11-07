import '../data/model/restaurant.dart';

abstract interface class IrestaurantService {
  Future<List<Restaurant>> fetchNearbyRestaurants(final int locationId);
  Future<void> addRestaurantToItinerary(
    final int restaurantId,
    final int itineraryId,
  );
}
