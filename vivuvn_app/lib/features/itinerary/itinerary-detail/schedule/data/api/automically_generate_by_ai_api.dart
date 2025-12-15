import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../dto/generate_itinerary_by_ai_request.dart';
import '../dto/generate_itinerary_by_ai_response.dart';

final automaticallyGenerateByAiProvider =
    Provider.autoDispose<AutomaticallyGenerateByAi>((final ref) {
      final dio = ref.watch(networkServiceProvider);
      return AutomaticallyGenerateByAi(dio);
    });

class AutomaticallyGenerateByAi {
  final Dio _dio;
  AutomaticallyGenerateByAi(this._dio);

  /// POST /api/v1/itineraries/{itineraryId}/days/auto-generate
  Future<GenerateItineraryByAiResponse> generateItineraryByAi({
    required final GenerateItineraryByAiRequest request,
  }) async {
    final resp = await _dio.post(
      '/api/v1/itineraries/${request.itineraryId}/days/auto-generate',
      data: request.toJson(),
      // options: Options(
      //   receiveTimeout: const Duration(milliseconds: 300),
      //   // sendTimeout: const Duration(minutes: 1),
      // ),
    );
    return GenerateItineraryByAiResponse.fromJson(resp.data as Map<String, dynamic>);
  }
}
