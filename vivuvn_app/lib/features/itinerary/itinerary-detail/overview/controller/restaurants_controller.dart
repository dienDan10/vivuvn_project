import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../detail/controller/itinerary_detail_controller.dart';
import '../data/dto/add_restaurant_request.dart';
import '../models/location.dart';
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

  // Form methods (add-only)
  void initializeForm() {
    state = state.copyWith(
      formSelectedLocation: null,
      formMealDate: DateTime.now(),
      formMealTime: DateFormat('HH:mm:ss').format(DateTime.now()),
    );
  }

  void setFormLocation(final Location location) {
    state = state.copyWith(formSelectedLocation: location);
  }

  void setFormMealDate(final DateTime date) {
    state = state.copyWith(formMealDate: date);
  }

  void setFormMealTime(final String time) {
    state = state.copyWith(formMealTime: time);
  }

  Future<bool> saveForm() async {
    if (state.formDisplayName.isEmpty) return false;

    final googlePlaceId = state.formSelectedLocation?.googlePlaceId;
    if (googlePlaceId == null) return false;

    final date = state.formMealDate ?? DateTime.now();
    final timeStr = state.formMealTime ?? DateFormat('HH:mm:ss').format(DateTime.now());
    final parts = timeStr.split(':');
    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts.length > 2 ? int.parse(parts[2]) : 0,
    );
    return await addRestaurant(
      googlePlaceId: googlePlaceId,
      mealDate: combined,
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
      initializeForm();
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
    state = state.copyWith(
      savingRestaurantId: id,
      savingType: RestaurantSavingType.date,
    );
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurantDate(
        itineraryId: state.itineraryId!,
        id: id,
        date: date,
      );
      await loadRestaurants(state.itineraryId);
      state = state.copyWith(savingRestaurantId: null, savingType: null);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        error: errorMsg,
        savingRestaurantId: null,
        savingType: null,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        error: 'Unknown error',
        savingRestaurantId: null,
        savingType: null,
      );
      return false;
    }
  }

  Future<bool> updateRestaurantTime({
    required final String id,
    required final String time,
  }) async {
    state = state.copyWith(
      savingRestaurantId: id,
      savingType: RestaurantSavingType.time,
    );
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurantTime(
        itineraryId: state.itineraryId!,
        id: id,
        time: time,
      );
      await loadRestaurants(state.itineraryId);
      state = state.copyWith(savingRestaurantId: null, savingType: null);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        error: errorMsg,
        savingRestaurantId: null,
        savingType: null,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        error: 'Unknown error',
        savingRestaurantId: null,
        savingType: null,
      );
      return false;
    }
  }

  Future<bool> updateRestaurantNote({
    required final String id,
    required final String note,
  }) async {
    state = state.copyWith(
      savingRestaurantId: id,
      savingType: RestaurantSavingType.note,
    );
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurantNote(
        itineraryId: state.itineraryId!,
        id: id,
        note: note,
      );
      await loadRestaurants(state.itineraryId);
      state = state.copyWith(savingRestaurantId: null, savingType: null);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        error: errorMsg,
        savingRestaurantId: null,
        savingType: null,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        error: 'Unknown error',
        savingRestaurantId: null,
        savingType: null,
      );
      return false;
    }
  }

  Future<bool> updateRestaurantCost({
    required final String id,
    required final double cost,
  }) async {
    state = state.copyWith(
      savingRestaurantId: id,
      savingType: RestaurantSavingType.cost,
    );
    try {
      final service = ref.read(restaurantsServiceProvider);
      await service.updateRestaurantCost(
        itineraryId: state.itineraryId!,
        id: id,
        cost: cost,
      );
      await loadRestaurants(state.itineraryId);
      state = state.copyWith(savingRestaurantId: null, savingType: null);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        error: errorMsg,
        savingRestaurantId: null,
        savingType: null,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        error: 'Unknown error',
        savingRestaurantId: null,
        savingType: null,
      );
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
