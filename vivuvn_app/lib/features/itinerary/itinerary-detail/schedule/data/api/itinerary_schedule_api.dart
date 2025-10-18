import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/data/remote/network/network_service.dart';
import '../../model/itinerary_day.dart';

final itineraryScheduleApiProvider =
    Provider.autoDispose<ItineraryScheduleApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return ItineraryScheduleApi(dio);
});

class ItineraryScheduleApi {
  final Dio _dio;
  ItineraryScheduleApi(this._dio);

  Future<List<ItineraryDay>> getItineraryDays(final int itineraryId) async {
    final response = await _dio.get('/api/v1/itineraries/$itineraryId/days');
    final data = response.data as List<dynamic>;
    return data.map((final e) => ItineraryDay.fromJson(e)).toList();
  }
}
