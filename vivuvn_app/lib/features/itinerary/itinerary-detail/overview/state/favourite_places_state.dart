import '../data/dto/favourite_places_response.dart';

class FavouritePlacesState {
  final bool isLoading;
  final List<FavouritePlacesResponse> places;
  final String? error;

  FavouritePlacesState({
    this.isLoading = false,
    this.places = const [],
    this.error,
  });

  FavouritePlacesState copyWith({
    final bool? isLoading,
    final List<FavouritePlacesResponse>? places,
    final String? error,
  }) {
    return FavouritePlacesState(
      isLoading: isLoading ?? this.isLoading,
      places: places ?? this.places,
      error: error,
    );
  }
}
