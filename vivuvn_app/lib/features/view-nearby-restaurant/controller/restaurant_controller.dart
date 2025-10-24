import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../service/restaurant_service.dart';
import '../state/neary_by_restaurant_state.dart';

class RestaurantController extends AutoDisposeNotifier<NearbyRestaurantState> {
  @override
  NearbyRestaurantState build() {
    return NearbyRestaurantState();
  }

  Future<void> fetchNearbyRestaurants(final int locationId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final restaurants = await ref
          .read(restaurantServiceProvider)
          .fetchNearbyRestaurants(locationId);

      state = state.copyWith(restaurants: restaurants);
    } on DioException catch (e) {
      state = state.copyWith(
        errorMessage: DioExceptionHandler.handleException(e),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final restaurantControllerProvider =
    AutoDisposeNotifierProvider<RestaurantController, NearbyRestaurantState>(
      () => RestaurantController(),
    );
