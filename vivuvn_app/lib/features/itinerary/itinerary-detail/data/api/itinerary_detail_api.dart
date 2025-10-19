import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/network/network_service.dart';
import '../../../view-itinerary-list/models/itinerary.dart';

final itineraryDetailApiProvider = Provider.autoDispose<ItineraryDetailApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return ItineraryDetailApi(dio);
});

class ItineraryDetailApi {
  final Dio _dio;
  ItineraryDetailApi(this._dio);

  Future<Itinerary> getItineraryDetail(final int id) async {
    final response = await _dio.get('/api/v1/itineraries/$id');

    final data = response.data;
    return Itinerary.fromJson(data as Map<String, dynamic>);
  }
}
