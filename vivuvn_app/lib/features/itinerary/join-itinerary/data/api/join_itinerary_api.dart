import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/network/network_service.dart';

final class JoinItineraryApi {
  final Dio _dio;

  JoinItineraryApi(this._dio);

  Future<void> joinByInviteCode(final String inviteCode) async {
    await _dio.post(
      '/api/v1/itineraries/join',
      data: {
        'inviteCode': inviteCode,
      },
    );
  }
}

final joinItineraryApiProvider = Provider.autoDispose<JoinItineraryApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return JoinItineraryApi(dio);
});


