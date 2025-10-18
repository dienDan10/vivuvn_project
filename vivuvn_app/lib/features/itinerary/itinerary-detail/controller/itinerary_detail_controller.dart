import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/auth/auth_controller.dart';
import '../../../../core/data/remote/exception/dio_exception_handler.dart';
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

  Future<void> setItineraryId(final int id) async {
    if (state.itineraryId == id && state.itinerary != null) return;

    state = state.copyWith(itineraryId: id, isLoading: true, error: null);

    try {
      final data = await ref
          .read(itineraryDetailServiceProvider)
          .getItineraryDetail(id);
      state = state.copyWith(itinerary: data, isLoading: false);
    } on DioException catch (e) {
      // Kiểm tra lỗi Unauthorized
      if (e.response?.statusCode == 401) {
        // Xoá token và set trạng thái auth = unauthenticated
        await ref.read(authControllerProvider.notifier).logout();
        state = state.copyWith(error: 'unauthorized', isLoading: false);
      } else {
        final errorMsg = DioExceptionHandler.handleException(e);
        state = state.copyWith(error: errorMsg, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: 'unknown error', isLoading: false);
    }
  }
}
