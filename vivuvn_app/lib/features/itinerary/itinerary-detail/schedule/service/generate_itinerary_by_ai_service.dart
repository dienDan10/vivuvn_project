import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/automically_generate_by_ai_api.dart';
import '../data/dto/generate_itinerary_by_ai_request.dart';
import '../data/dto/generate_itinerary_by_ai_response.dart';
import 'igenerate_itinerary_by_ai_service.dart';

final generateItineraryByAiProvider = Provider<IGenerateItineraryByAiService>((
  final ref,
) {
  final api = ref.read(automaticallyGenerateByAiProvider);
  return GenerateItineraryByAiService(api);
});

class GenerateItineraryByAiService implements IGenerateItineraryByAiService {
  final AutomaticallyGenerateByAi _api;

  GenerateItineraryByAiService(this._api);

  @override
  Future<GenerateItineraryByAiResponse> generateItineraryByAi(
    final GenerateItineraryByAiRequest request,
  ) async {
    final resp = await _api.generateItineraryByAi(request: request);
    final parsed = GenerateItineraryByAiResponse.fromDynamic(resp.data);
    return parsed;
  }
}
