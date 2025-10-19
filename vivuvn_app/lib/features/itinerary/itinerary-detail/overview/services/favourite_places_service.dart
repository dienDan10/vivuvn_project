import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/favourtie_places_api.dart';
import '../data/dto/add_favorite_place_request.dart';
import '../data/dto/delete_favorite_place_request.dart';
import '../data/dto/favourite_places_response.dart';

final favouritePlacesServiceProvider =
    Provider.autoDispose<IFavouritePlacesService>((final ref) {
      final favouritePlacesApi = ref.watch(favouritePlacesApiProvider);
      return FavouritePlacesService(favouritePlacesApi);
    });

abstract class IFavouritePlacesService {
  Future<List<FavouritePlacesResponse>> getFavouritePlaces(
    final int itineraryId,
  );
  Future<void> addPlaceToWishlist(final AddFavoritePlaceRequest request);
  Future<void> deletePlaceFromWishlist(
    final DeleteFavoritePlaceRequest request,
  );
}

class FavouritePlacesService implements IFavouritePlacesService {
  final FavouritePlacesApi _favouritePlacesApi;

  FavouritePlacesService(this._favouritePlacesApi);

  @override
  Future<List<FavouritePlacesResponse>> getFavouritePlaces(
    final int itineraryId,
  ) async {
    return await _favouritePlacesApi.getFavouritePlaces(itineraryId);
  }

  @override
  Future<void> addPlaceToWishlist(final AddFavoritePlaceRequest request) async {
    await _favouritePlacesApi.addPlaceToWishlist(request);
  }

  @override
  Future<void> deletePlaceFromWishlist(
    final DeleteFavoritePlaceRequest request,
  ) async {
    await _favouritePlacesApi.deletePlaceFromWishlist(request);
  }
}
