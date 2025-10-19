import '../modal/location.dart';

class SearchLocationState {
  final String searchText;
  final bool isLoading;
  final List<Location> locations;
  final String? error;

  SearchLocationState({
    this.searchText = '',
    this.isLoading = false,
    this.locations = const [],
    this.error,
  });

  SearchLocationState copyWith({
    final String? searchText,
    final bool? isLoading,
    final List<Location>? locations,
    final String? error,
  }) {
    return SearchLocationState(
      searchText: searchText ?? this.searchText,
      isLoading: isLoading ?? this.isLoading,
      locations: locations ?? this.locations,
      error: error,
    );
  }
}
