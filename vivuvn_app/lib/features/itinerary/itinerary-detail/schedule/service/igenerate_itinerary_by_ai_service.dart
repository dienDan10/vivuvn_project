import '../data/dto/generate_itinerary_by_ai_request.dart';
import '../data/dto/generate_itinerary_by_ai_response.dart';

abstract class IGenerateItineraryByAiService {
  Future<GenerateItineraryByAiResponse> generateItineraryByAi(
    final GenerateItineraryByAiRequest request,
  );
}
