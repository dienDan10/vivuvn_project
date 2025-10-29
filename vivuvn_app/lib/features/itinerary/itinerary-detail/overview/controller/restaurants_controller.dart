import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../controller/itinerary_detail_controller.dart';
import '../data/dto/add_restaurant_request.dart';
import '../modal/location.dart';
import '../services/restaurants_service.dart';
import '../state/restaurants_state.dart';

final restaurantsControllerProvider =
    AutoDisposeNotifierProvider<RestaurantsController, RestaurantsState>(
      () => RestaurantsController(),
    );

class RestaurantsController extends AutoDisposeNotifier<RestaurantsState> {
  @override
  RestaurantsState build() {
    // Auto-load restaurants when controller is first created and itineraryId is available
    final itineraryId = ref.watch(
      itineraryDetailControllerProvider.select((final s) => s.itineraryId),
    );

    if (itineraryId != null) {
      // Schedule load for next microtask to avoid modifying state during build
      Future.microtask(() => loadRestaurants(itineraryId));
    }

    return RestaurantsState();
  }

  Future<void> loadRestaurants(final int? itineraryId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      itineraryId: itineraryId,
    );
    try {
      final service = ref.read(restaurantsServiceProvider);
      final restaurants = await service.getRestaurants(itineraryId!);
      state = state.copyWith(restaurants: restaurants, isLoading: false);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg, isLoading: false);
    } catch (_) {
      state = state.copyWith(error: 'Unknown error', isLoading: false);
    }
  }

  Future<List<Location>> searchRestaurants(final String textQuery) async {
    final service = ref.read(restaurantsServiceProvider);
    final provinceName = ref
        .read(itineraryDetailControllerProvider)
        .itinerary
        ?.destinationProvinceName;
    return await service.searchRestaurants(
      textQuery: textQuery,
      provinceName: provinceName,
    );
  }

  Future<bool> addRestaurant({
    required final String googlePlaceId,
    required final DateTime mealDate,
    final String? imageUrl,
  }) async {
    try {
      final service = ref.read(restaurantsServiceProvider);
      final date = DateFormat('yyyy-MM-dd').format(mealDate);
      final time = DateFormat('HH:mm:ss').format(mealDate);
      final request = AddRestaurantRequest(
        googlePlaceId: googlePlaceId,
        date: date,
        time: time,
      );
      final int? itineraryId =
          state.itineraryId ??
          ref.read(itineraryDetailControllerProvider).itineraryId;
      if (itineraryId == null) {
        state = state.copyWith(error: 'Itinerary ID not set');
        return false;
      }
      await service.addRestaurant(itineraryId: itineraryId, request: request);
      await loadRestaurants(itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> updateRestaurant({
    required final String id,
    required final String name,
    required final String address,
    final DateTime? mealDate,
    final String? imageUrl,
  }) async {
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurant(
        itineraryId: state.itineraryId!,
        id: id,
        name: name,
        address: address,
        mealDate: mealDate,
        imageUrl: imageUrl,
      );
      await loadRestaurants(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> updateRestaurantDate({
    required final String id,
    required final DateTime date,
  }) async {
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurantDate(
        itineraryId: state.itineraryId!,
        id: id,
        date: date,
      );
      await loadRestaurants(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> updateRestaurantTime({
    required final String id,
    required final String time,
  }) async {
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurantTime(
        itineraryId: state.itineraryId!,
        id: id,
        time: time,
      );
      await loadRestaurants(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> updateRestaurantNote({
    required final String id,
    required final String note,
  }) async {
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurantNote(
        itineraryId: state.itineraryId!,
        id: id,
        note: note,
      );
      await loadRestaurants(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> updateRestaurantCost({
    required final String id,
    required final double cost,
  }) async {
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurantCost(
        itineraryId: state.itineraryId!,
        id: id,
        cost: cost,
      );
      await loadRestaurants(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> removeRestaurant(final String id) async {
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.deleteRestaurant(itineraryId: state.itineraryId!, id: id);
      await loadRestaurants(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
