import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/restaurant_api.dart';
import '../model/restaurant.dart';
import 'irestaurant_service.dart';

class RestaurantService implements IrestaurantService {
  final RestaurantApi _restaurantApi;

  RestaurantService(this._restaurantApi);

  @override
  Future<List<Restaurant>> fetchNearbyRestaurants(final int locationId) async {
    return await _restaurantApi.fetchNearbyRestaurants(locationId);
  }
}

final restaurantServiceProvider = Provider.autoDispose<IrestaurantService>((
  final ref,
) {
  final restaurantApi = ref.watch(restaurantApiProvider);
  return RestaurantService(restaurantApi);
});
