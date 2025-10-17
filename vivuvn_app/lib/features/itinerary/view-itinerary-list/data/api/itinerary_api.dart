import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/network/network_service.dart';
import '../../models/itinerary.dart';

final itineraryApiProvider = Provider.autoDispose<ItineraryApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return ItineraryApi(dio);
});

class ItineraryApi {
  final Dio _dio;
  ItineraryApi(this._dio);

  Future<List<Itinerary>> getItineraries() async {
    final response = await _dio.get('/api/v1/itineraries');

    if (response.data == null) return [];

    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map((final json) => Itinerary.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
