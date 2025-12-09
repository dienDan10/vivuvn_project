import '../../itinerary/create-itinerary/models/province.dart';
import '../data/dto/itinerary_dto.dart';

class SearchItinerariesState {
  final String searchText;
  final Province? selectedProvince;
  final List<ItineraryDto> itineraries;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String? errorMessage;
  final bool hasSearched;

  const SearchItinerariesState({
    this.searchText = '',
    this.selectedProvince,
    this.itineraries = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.errorMessage,
    this.hasSearched = false,
  });

  SearchItinerariesState copyWith({
    final String? searchText,
    final Province? selectedProvince,
    final bool clearSelectedProvince = false,
    final List<ItineraryDto>? itineraries,
    final bool? isLoading,
    final bool? isLoadingMore,
    final bool? hasMore,
    final int? page,
    final String? errorMessage,
    final bool? hasSearched,
  }) {
    return SearchItinerariesState(
      searchText: searchText ?? this.searchText,
      selectedProvince: clearSelectedProvince
          ? null
          : selectedProvince ?? this.selectedProvince,
      itineraries: itineraries ?? this.itineraries,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }
}
