import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../service/itinerary_detail_service.dart';
import '../state/itinerary_detail_state.dart';

final itineraryDetailControllerProvider =
    AutoDisposeNotifierProvider<
      ItineraryDetailController,
      ItineraryDetailState
    >(() => ItineraryDetailController());

class ItineraryDetailController
    extends AutoDisposeNotifier<ItineraryDetailState> {
  @override
  ItineraryDetailState build() => ItineraryDetailState();

  /// Lưu ID và fetch detail
  void setItineraryId(final int id) async {
    state = state.copyWith(itineraryId: id);
  }

  /// Fetch itinerary detail by ID
  Future<void> fetchItineraryDetail() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await ref
          .read(itineraryDetailServiceProvider)
          .getItineraryDetail(state.itineraryId!);
      state = state.copyWith(itinerary: data);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
    } catch (e) {
      state = state.copyWith(error: 'unknown error');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
