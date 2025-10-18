import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../service/itinerary_schedule_service.dart';
import '../state/itinerary_schedule_state.dart';

final itineraryScheduleControllerProvider =
    AutoDisposeNotifierProvider<
      ItineraryScheduleController,
      ItineraryScheduleState
    >(() => ItineraryScheduleController());

class ItineraryScheduleController
    extends AutoDisposeNotifier<ItineraryScheduleState> {
  @override
  ItineraryScheduleState build() => ItineraryScheduleState();

  Future<void> fetchDays(final int? itineraryId) async {
    if (itineraryId == null) {
      state = state.copyWith(error: 'Thiếu itineraryId', isLoading: false);
      return;
    }

    if (state.itineraryId == itineraryId && state.days.isNotEmpty) return;

    state = state.copyWith(
      itineraryId: itineraryId,
      isLoading: true,
      error: null,
    );

    try {
      final data = await ref
          .read(itineraryScheduleServiceProvider)
          .getItineraryDays(itineraryId);
      state = state.copyWith(days: data, isLoading: false);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void selectDay(final int index) {
    state = state.copyWith(selectedIndex: index);
  }
}
