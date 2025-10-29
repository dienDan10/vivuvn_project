import '../model/restaurant.dart';

abstract interface class IrestaurantService {
  Future<List<Restaurant>> fetchNearbyRestaurants(final int locationId);
}
