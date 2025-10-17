import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../services/create_itinerary_service.dart';
import '../state/search_province_state.dart';

final searchProvinceControllerProvider =
    AutoDisposeNotifierProvider<SearchProvinceController, SearchProvinceState>(
      () => SearchProvinceController(),
    );

class SearchProvinceController
    extends AutoDisposeNotifier<SearchProvinceState> {
  @override
  build() {
    return SearchProvinceState();
  }

  Future<void> searchProvince(final String queryText) async {
    final createItineraryService = ref.read(createItineraryServiceProvider);
    try {
      state = state.copyWith(isLoading: true, error: null);
      await Future.delayed(const Duration(milliseconds: 1000));
      final provinces = await createItineraryService.searchProvince(queryText);
      state = state.copyWith(provinces: provinces);
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
    } catch (e) {
      state = state.copyWith(error: 'Something went wrong!');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearProvinces() {
    state = state.copyWith(provinces: []);
  }
}
