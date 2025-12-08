class SearchItinerariesState {
  final String searchText;
  final SortOrder sortOrder;

  const SearchItinerariesState({
    this.searchText = '',
    this.sortOrder = SortOrder.nearest,
  });

  SearchItinerariesState copyWith({
    final String? searchText,
    final SortOrder? sortOrder,
  }) {
    return SearchItinerariesState(
      searchText: searchText ?? this.searchText,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

enum SortOrder {
  nearest, // Gần với hiện tại nhất (mặc định)
  oldest, // Cũ nhất
}
