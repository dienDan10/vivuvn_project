import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/validator/validation_exception.dart';
import '../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../data/dto/create_itinerary_request.dart';
import '../data/dto/create_itinerary_response.dart';
import '../models/province.dart';
import '../services/create_itinerary_service.dart';
import '../state/create_itinerary_state.dart';

class CreateItineraryController
    extends AutoDisposeNotifier<CreateItineraryState> {
  @override
  build() {
    return CreateItineraryState();
  }

  Future<List<Province>> searchProvince(final String queryText) async {
    final createItineraryService = ref.read(createItineraryServiceProvider);
    try {
      final provinces = await createItineraryService.searchProvince(queryText);
      return provinces;
    } on DioException catch (_) {
      return [];
    }
  }

  void setStartProvince(final Province province) {
    state = state.copyWith(startProvince: province);
  }

  void setDestinationProvince(final Province province) {
    state = state.copyWith(destinationProvince: province);
  }

  void setDates(final DateTime? start, final DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  Future<CreateItineraryResponse?> createItinerary() async {
    try {
      _validateInputs();

      state = state.copyWith(isLoading: true, error: null);

      final createItineraryService = ref.read(createItineraryServiceProvider);

      final request = CreateItineraryRequest(
        name: 'Du lịch ${state.destinationProvince!.name}',
        startProvinceId: state.startProvince!.id,
        destinationProvinceId: state.destinationProvince!.id,
        startDate: state.startDate!,
        endDate: state.endDate!,
      );
      final response = await createItineraryService.createItinerary(request);
      return response;
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
    } on ValidationException catch (e) {
      state = state.copyWith(error: e.toString());
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }

    return null;
  }

  void _validateInputs() {
    if (state.startProvince == null) {
      throw ValidationException('Bạn cần chọn nơi bắt đầu.');
    }
    if (state.destinationProvince == null) {
      throw ValidationException('Bạn cần chọn điểm đến.');
    }
    if (state.startDate == null || state.endDate == null) {
      throw ValidationException(
        'Bạn cần chọn khoảng thời gian cho hành trình.',
      );
    }
  }
}

final createItineraryControllerProvider =
    AutoDisposeNotifierProvider<
      CreateItineraryController,
      CreateItineraryState
    >(() => CreateItineraryController());
