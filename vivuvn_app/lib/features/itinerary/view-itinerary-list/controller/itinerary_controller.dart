import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../service/itinerary_service.dart';
import '../state/itinerary_state.dart';

final itineraryControllerProvider =
    AutoDisposeNotifierProvider<ItineraryController, ItineraryState>(
      () => ItineraryController(),
    );

class ItineraryController extends AutoDisposeNotifier<ItineraryState> {
  @override
  ItineraryState build() => ItineraryState();

  Future<void> fetchItineraries() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await ref.read(itineraryServiceProvider).getItineraries();
      state = state.copyWith(itineraries: data, isLoading: false);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'unknown error', isLoading: false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
