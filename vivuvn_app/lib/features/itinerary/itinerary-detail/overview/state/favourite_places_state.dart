import '../data/dto/favourite_places_response.dart';

class FavouritePlacesState {
  final bool isLoading;
  final List<FavouritePlacesResponse> places;
  final String? error;
  final int? itineraryId;

  FavouritePlacesState({
    this.isLoading = false,
    this.places = const [],
    this.error,
    this.itineraryId,
  });

  FavouritePlacesState copyWith({
    final bool? isLoading,
    final List<FavouritePlacesResponse>? places,
    final String? error,
    final int? itineraryId,
  }) {
    return FavouritePlacesState(
      isLoading: isLoading ?? this.isLoading,
      places: places ?? this.places,
      error: error,
      itineraryId: itineraryId ?? this.itineraryId,
    );
  }
}
