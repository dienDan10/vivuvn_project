import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    print(province.name);
  }

  void setDestinationProvince(final Province province) {
    state = state.copyWith(destinationProvince: province);
    print(province.name);
  }
}

final createItineraryControllerProvider =
    AutoDisposeNotifierProvider<
      CreateItineraryController,
      CreateItineraryState
    >(() => CreateItineraryController());
