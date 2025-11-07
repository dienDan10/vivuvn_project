import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/restaurant_api.dart';
import '../data/dtos/add_to_itinerary_request.dart';
import '../data/model/restaurant.dart';
import 'irestaurant_service.dart';

class RestaurantService implements IrestaurantService {
  final RestaurantApi _restaurantApi;

  RestaurantService(this._restaurantApi);

  @override
  Future<List<Restaurant>> fetchNearbyRestaurants(final int locationId) async {
    return await _restaurantApi.fetchNearbyRestaurants(locationId);
  }

  @override
  Future<void> addRestaurantToItinerary(
    final int restaurantId,
    final int itineraryId,
  ) async {
    return await _restaurantApi.addRestaurantToItinerary(
      itineraryId,
      AddToItineraryRequest(restaurantId: restaurantId),
    );
  }
}

final restaurantServiceProvider = Provider.autoDispose<IrestaurantService>((
  final ref,
) {
  final restaurantApi = ref.watch(restaurantApiProvider);
  return RestaurantService(restaurantApi);
});
