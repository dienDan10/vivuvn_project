import '../models/province.dart';

class SearchProvinceState {
  final String searchText;
  final bool isLoading;
  final List<Province> provinces;
  final String? error;

  SearchProvinceState({
    this.searchText = '',
    this.isLoading = false,
    this.provinces = const [],
    this.error,
  });

  SearchProvinceState copyWith({
    final String? searchText,
    final bool? isLoading,
    final List<Province>? provinces,
    final String? error,
  }) {
    return SearchProvinceState(
      searchText: searchText ?? this.searchText,
      isLoading: isLoading ?? this.isLoading,
      provinces: provinces ?? this.provinces,
      error: error,
    );
  }
}
