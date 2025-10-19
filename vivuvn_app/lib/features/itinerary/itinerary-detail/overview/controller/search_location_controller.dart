import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dto/search_location_response.dart';
import '../services/search_location_service.dart';
import '../state/search_location_state.dart';

final searchLocationControllerProvider =
    AutoDisposeNotifierProvider<SearchLocationController, SearchLocationState>(
      () => SearchLocationController(),
    );

class SearchLocationController
    extends AutoDisposeNotifier<SearchLocationState> {
  @override
  build() {
    return SearchLocationState();
  }

  Future<List<SearchLocationResponse>> searchLocation(
    final String queryText,
  ) async {
    final searchLocationService = ref.read(searchLocationServiceProvider);
    try {
      final provinces = await searchLocationService.searchLocations(queryText);
      return provinces;
    } on DioException catch (_) {
      return [];
    }
  }

  void clearLocations() {
    state = state.copyWith(locations: []);
  }
}
