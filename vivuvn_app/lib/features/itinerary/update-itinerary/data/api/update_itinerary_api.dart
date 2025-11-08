import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/network/network_service.dart';

final updateItineraryApiProvider = Provider.autoDispose<UpdateItineraryApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return UpdateItineraryApi(dio);
});

class UpdateItineraryApi {
  final Dio _dio;
  UpdateItineraryApi(this._dio);

  Future<void> updateName({
    required final int itineraryId,
    required final String name,
  }) async {
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/name',
      data: {'name': name},
    );
  }

  Future<void> setPublic({
    required final int itineraryId,
  }) async {
    await _dio.put('/api/v1/itineraries/$itineraryId/public');
  }

  Future<void> setPrivate({
    required final int itineraryId,
  }) async {
    await _dio.put('/api/v1/itineraries/$itineraryId/private');
  }
}


