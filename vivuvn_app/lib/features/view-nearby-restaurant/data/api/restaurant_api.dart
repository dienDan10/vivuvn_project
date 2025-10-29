import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/network/network_service.dart';
import '../../model/restaurant.dart';

class RestaurantApi {
  final Dio _dio;
  RestaurantApi(this._dio);

  Future<List<Restaurant>> fetchNearbyRestaurants(final int locationId) async {
    final response = await _dio.get(
      '/api/v1/locations/$locationId/restaurants',
    );

    final data = response.data as List<dynamic>;
    return data.map((final item) => Restaurant.fromMap(item)).toList();
  }
}

final restaurantApiProvider = Provider.autoDispose<RestaurantApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return RestaurantApi(dio);
});
