import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/search_location_api.dart';
import '../data/dto/search_location_response.dart';

final searchLocationServiceProvider =
    Provider.autoDispose<ISearchLocationService>((final ref) {
      final searchLocationApi = ref.watch(searchLocationApiProvider);
      return SearchLocationService(searchLocationApi);
    });

abstract class ISearchLocationService {
  Future<List<SearchLocationResponse>> searchLocations(final String queryText);
}

class SearchLocationService implements ISearchLocationService {
  final SearchLocationApi _searchLocationApi;

  SearchLocationService(this._searchLocationApi);

  @override
  Future<List<SearchLocationResponse>> searchLocations(
    final String queryText,
  ) async {
    return await _searchLocationApi.searchLocations(queryText);
  }
}
