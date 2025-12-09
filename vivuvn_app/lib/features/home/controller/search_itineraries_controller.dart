import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../itinerary/create-itinerary/models/province.dart';
import '../service/home_service_impl.dart';
import '../state/search_itineraries_state.dart';

class SearchItinerariesController
    extends StateNotifier<SearchItinerariesState> {
  SearchItinerariesController(this._ref)
      : super(const SearchItinerariesState());

  static const int _pageSize = 15;
  final Ref _ref;

  void updateSearchText(final String text) {
    state = state.copyWith(
      searchText: text,
      clearSelectedProvince: true,
      hasSearched: false,
    );
    // TODO: Implement search by province
  }

  void selectProvince(final Province province) {
    state = state.copyWith(
      searchText: province.name,
      selectedProvince: province,
      errorMessage: null,
      itineraries: [],
      hasMore: true,
      page: 1,
      hasSearched: false,
    );
    // TODO: Trigger search by selected province
  }

  void clearSearch() {
    state = state.copyWith(
      searchText: '',
      clearSelectedProvince: true,
      itineraries: [],
      hasMore: true,
      page: 1,
      errorMessage: null,
      hasSearched: false,
    );
  }

  Future<void> searchByProvince() async {
    if (state.selectedProvince == null) return;
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      page: 1,
      hasMore: true,
      itineraries: [],
      errorMessage: null,
      hasSearched: false,
    );

    try {
      final itineraries = await _ref.read(homeServiceProvider).getPublicItineraries(
            page: 1,
            pageSize: _pageSize,
            sortByDate: true,
            isDescending: false,
            provinceId: state.selectedProvince!.id,
          );

      state = state.copyWith(
        itineraries: itineraries,
        hasMore: itineraries.length >= _pageSize,
        page: 1,
        isLoading: false,
        hasSearched: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        hasSearched: true,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.selectedProvince == null) return;
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final itineraries = await _ref.read(homeServiceProvider).getPublicItineraries(
            page: nextPage,
            pageSize: _pageSize,
            sortByDate: true,
            isDescending: false,
            provinceId: state.selectedProvince!.id,
          );

      state = state.copyWith(
        itineraries: [...state.itineraries, ...itineraries],
        hasMore: itineraries.length >= _pageSize,
        page: nextPage,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final searchItinerariesControllerProvider =
    StateNotifierProvider.autoDispose<
      SearchItinerariesController,
      SearchItinerariesState
    >((final ref) {
      return SearchItinerariesController(ref);
    });
