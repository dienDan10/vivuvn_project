import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
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

  Future<void> searchLocation(final String queryText) async {
    final searchLocationService = ref.read(searchLocationServiceProvider);
    try {
      state = state.copyWith(isLoading: true, error: null);
      await Future.delayed(const Duration(milliseconds: 300));
      final locations = await searchLocationService.searchLocations(queryText);
      state = state.copyWith(locations: locations);
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
    } catch (e) {
      state = state.copyWith(error: 'Something went wrong!');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearLocations() {
    state = state.copyWith(locations: []);
  }
}
