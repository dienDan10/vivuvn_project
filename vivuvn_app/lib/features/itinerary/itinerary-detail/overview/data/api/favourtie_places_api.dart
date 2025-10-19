import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../dto/add_favorite_place_request.dart';
import '../dto/delete_favorite_place_request.dart';
import '../dto/favourite_places_response.dart';

final favouritePlacesApiProvider = Provider.autoDispose<FavouritePlacesApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return FavouritePlacesApi(dio);
});

class FavouritePlacesApi {
  final Dio _dio;

  FavouritePlacesApi(this._dio);

  /// Get all favourite places by itineraryId
  Future<List<FavouritePlacesResponse>> getFavouritePlaces(
    final int itineraryId,
  ) async {
    final response = await _dio.get(
      '/api/v1/itineraries/$itineraryId/favorite-places',
    );

    if (response.data == null) {
      return [];
    }

    final List<dynamic> jsonList = response.data as List<dynamic>;

    return jsonList
        .map(
          (final json) =>
              FavouritePlacesResponse.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Add a place to wishlist
  Future<void> addPlaceToWishlist(final AddFavoritePlaceRequest request) async {
    await _dio.post(
      '/api/v1/itineraries/${request.itineraryId}/favorite-places',
      data: {'locationId': request.locationId},
    );
  }

  /// Delete a place from wishlist
  Future<void> deletePlaceFromWishlist(
    final DeleteFavoritePlaceRequest request,
  ) async {
    await _dio.delete(
      '/api/v1/itineraries/${request.itineraryId}/favorite-places/${request.locationId}',
    );
  }
}
