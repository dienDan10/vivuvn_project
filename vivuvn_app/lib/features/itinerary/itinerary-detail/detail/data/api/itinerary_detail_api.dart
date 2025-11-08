import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../../../../view-itinerary-list/models/itinerary.dart';

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
    return Itinerary.fromMap(data as Map<String, dynamic>);
  }

  Future<void> updateGroupSize({
    required final int itineraryId,
    required final int groupSize,
  }) async {
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/group-size',
      data: {'groupSize': groupSize},
    );
  }

  Future<String> getInviteCode(final int itineraryId) async {
    final response = await _dio.post('/api/v1/itineraries/$itineraryId/invite-code');
    final data = response.data as Map<String, dynamic>;
    return data['inviteCode'] as String;
  }

  Future<void> updateTransportation({
    required final int itineraryId,
    required final String transportation,
  }) async {
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/transportation',
      data: {'transportation': transportation},
    );
  }
}
