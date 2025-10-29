import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/restaurants_api.dart';
import '../data/dto/add_restaurant_request.dart';
import '../data/dto/restaurant_item_response.dart';
import '../modal/location.dart';

final restaurantsServiceProvider = Provider.autoDispose<IRestaurantsService>((
  final ref,
) {
  final api = ref.watch(restaurantsApiProvider);
  return RestaurantsService(api);
});

abstract class IRestaurantsService {
  Future<List<RestaurantItemResponse>> getRestaurants(final int itineraryId);
  Future<List<Location>> searchRestaurants({
    final String textQuery = '',
    final String? provinceName,
  });
  Future<void> addRestaurant({
    required final int itineraryId,
    required final AddRestaurantRequest request,
  });
  Future<void> updateRestaurant({
    required final int itineraryId,
    required final String id,
    required final String name,
    required final String address,
    final DateTime? mealDate,
    final String? imageUrl,
  });
  Future<void> updateRestaurantDate({
    required final int itineraryId,
    required final String id,
    required final DateTime date,
  });
  Future<void> updateRestaurantTime({
    required final int itineraryId,
    required final String id,
    required final String time,
  });
  Future<void> updateRestaurantNote({
    required final int itineraryId,
    required final String id,
    required final String note,
  });
  Future<void> updateRestaurantCost({
    required final int itineraryId,
    required final String id,
    required final double cost,
  });
  Future<void> deleteRestaurant({
    required final int itineraryId,
    required final String id,
  });
}

class RestaurantsService implements IRestaurantsService {
  final RestaurantsApi _api;

  RestaurantsService(this._api);

  @override
  Future<List<RestaurantItemResponse>> getRestaurants(
    final int itineraryId,
  ) async {
    return _api.getRestaurants(itineraryId);
  }

  @override
  Future<List<Location>> searchRestaurants({
    final String textQuery = '',
    final String? provinceName,
  }) async {
    return _api.searchRestaurants(
      textQuery: textQuery,
      provinceName: provinceName,
    );
  }

  @override
  Future<void> addRestaurant({
    required final int itineraryId,
    required final AddRestaurantRequest request,
  }) async {
    await _api.addRestaurant(itineraryId: itineraryId, request: request);
  }

  @override
  Future<void> updateRestaurant({
    required final int itineraryId,
    required final String id,
    required final String name,
    required final String address,
    final DateTime? mealDate,
    final String? imageUrl,
  }) async {
    // Full update removed; callers should use per-field APIs.
    // Keep a no-op to avoid breaking existing implementations.
    return Future.value();
  }

  @override
  Future<void> updateRestaurantDate({
    required final int itineraryId,
    required final String id,
    required final DateTime date,
  }) async {
    await _api.updateRestaurantDate(
      itineraryId: itineraryId,
      id: id,
      date: date,
    );
  }

  @override
  Future<void> updateRestaurantTime({
    required final int itineraryId,
    required final String id,
    required final String time,
  }) async {
    await _api.updateRestaurantTime(
      itineraryId: itineraryId,
      id: id,
      time: time,
    );
  }

  @override
  Future<void> updateRestaurantNote({
    required final int itineraryId,
    required final String id,
    required final String note,
  }) async {
    await _api.updateRestaurantNote(
      itineraryId: itineraryId,
      id: id,
      note: note,
    );
  }

  @override
  Future<void> updateRestaurantCost({
    required final int itineraryId,
    required final String id,
    required final double cost,
  }) async {
    await _api.updateRestaurantCost(
      itineraryId: itineraryId,
      id: id,
      cost: cost,
    );
  }

  @override
  Future<void> deleteRestaurant({
    required final int itineraryId,
    required final String id,
  }) async {
    await _api.deleteRestaurant(itineraryId: itineraryId, id: id);
  }
}
