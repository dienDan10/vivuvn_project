import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/search_itineraries_state.dart';

class SearchItinerariesController
    extends StateNotifier<SearchItinerariesState> {
  SearchItinerariesController() : super(const SearchItinerariesState());

  void updateSearchText(final String text) {
    state = state.copyWith(searchText: text);
    // TODO: Implement search by destination
  }

  void updateSortOrder(final SortOrder order) {
    state = state.copyWith(sortOrder: order);
    // TODO: Refresh results with new sort order
  }

  void clearSearch() {
    state = state.copyWith(searchText: '');
  }
}

final searchItinerariesControllerProvider =
    StateNotifierProvider.autoDispose<
      SearchItinerariesController,
      SearchItinerariesState
    >((final ref) {
      return SearchItinerariesController();
    });
