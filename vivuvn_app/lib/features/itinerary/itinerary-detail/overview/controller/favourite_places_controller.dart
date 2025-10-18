import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../services/favourite_places_service.dart';
import '../state/favourite_places_state.dart';

final favouritePlacesControllerProvider =
    AutoDisposeNotifierProvider<
      FavouritePlacesController,
      FavouritePlacesState
    >(() => FavouritePlacesController());

class FavouritePlacesController
    extends AutoDisposeNotifier<FavouritePlacesState> {
  @override
  FavouritePlacesState build() {
    return FavouritePlacesState();
  }

  /// Load favourite places by itineraryId
  Future<void> loadFavouritePlaces(final int itineraryId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(favouritePlacesServiceProvider);
      final places = await service.getFavouritePlaces(itineraryId);
      state = state.copyWith(places: places, isLoading: false);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Unknown error', isLoading: false);
    }
  }

  /// Add a place to wishlist
  Future<bool> addPlaceToWishlist(
    final int itineraryId,
    final int locationId,
  ) async {
    try {
      final service = ref.read(favouritePlacesServiceProvider);
      await service.addPlaceToWishlist(itineraryId, locationId);

      // Reload the list after adding
      await loadFavouritePlaces(itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  /// Delete a place from wishlist
  Future<bool> deletePlaceFromWishlist(
    final int itineraryId,
    final int locationId,
  ) async {
    try {
      final service = ref.read(favouritePlacesServiceProvider);
      await service.deletePlaceFromWishlist(itineraryId, locationId);

      // Reload the list after deletion
      await loadFavouritePlaces(itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }
}
