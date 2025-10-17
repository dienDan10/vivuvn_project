import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/network/network_service.dart';
import '../../models/province.dart';
import '../dto/create_itinerary_request.dart';
import '../dto/create_itinerary_response.dart';

final class CreateItineraryApi {
  final Dio _dio;

  CreateItineraryApi(this._dio);

  Future<CreateItineraryResponse> createItinerary(
    final CreateItineraryRequest request,
  ) async {
    final response = await _dio.post(
      '/api/v1/itineraries',
      data: request.toMap(),
    );
    return CreateItineraryResponse.fromMap(response.data);
  }

  Future<List<Province>> searchProvince(final String queryText) async {
    final response = await _dio.get('/api/v1/provinces/search?name=$queryText');

    if (response.data == null) return [];

    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map((final json) => Province.fromMap(json as Map<String, dynamic>))
        .toList();
  }
}

final createItineraryApiProvider = Provider.autoDispose<CreateItineraryApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return CreateItineraryApi(dio);
});
