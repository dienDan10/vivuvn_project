import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../../models/location.dart';
import '../dto/add_restaurant_request.dart';
import '../dto/restaurant_item_response.dart';

final restaurantsApiProvider = Provider.autoDispose<RestaurantsApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return RestaurantsApi(dio);
});

class RestaurantsApi {
  final Dio _dio;

  RestaurantsApi(this._dio);

  Future<List<RestaurantItemResponse>> getRestaurants(
    final int itineraryId,
  ) async {
    final response = await _dio.get(
      '/api/v1/itineraries/$itineraryId/restaurants',
    );
    if (response.data == null) return [];
    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map(
          (final json) =>
              RestaurantItemResponse.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<Location>> searchRestaurants({
    final String textQuery = '',
    final String? provinceName,
  }) async {
    final response = await _dio.get(
      '/api/v1/locations/restaurants/search',
      queryParameters: {
        'textQuery': textQuery,
        'provinceName': provinceName ?? '',
      },
    );
    if (response.data == null) return [];
    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map((final json) => Location.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addRestaurant({
    required final int itineraryId,
    required final AddRestaurantRequest request,
  }) async {
    await _dio.post(
      '/api/v1/itineraries/$itineraryId/restaurants/search',
      data: request.toJson(),
    );
  }

  // Removed full-update endpoint; use per-field endpoints instead.

  Future<void> updateRestaurantDate({
    required final int itineraryId,
    required final String id,
    required final DateTime date,
  }) async {
    // send date in yyyy-MM-dd format
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/restaurants/$id/dates',
      data: {'date': DateFormat('yyyy-MM-dd').format(date)},
    );
  }

  Future<void> updateRestaurantTime({
    required final int itineraryId,
    required final String id,
    required final String time,
  }) async {
    // time expected as HH:mm:ss
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/restaurants/$id/times',
      data: {'time': time},
    );
  }

  Future<void> updateRestaurantNote({
    required final int itineraryId,
    required final String id,
    required final String note,
  }) async {
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/restaurants/$id/notes',
      data: {'notes': note},
    );
  }

  Future<void> updateRestaurantCost({
    required final int itineraryId,
    required final String id,
    required final double cost,
  }) async {
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/restaurants/$id/costs',
      data: {'cost': cost},
    );
  }

  Future<void> deleteRestaurant({
    required final int itineraryId,
    required final String id,
  }) async {
    await _dio.delete('/api/v1/itineraries/$itineraryId/restaurants/$id');
  }
}
