import '../data/dto/generate_itinerary_by_ai_request.dart';

abstract class IGenerateItineraryByAiService {
  Future<void> generateItineraryByAi(
    final GenerateItineraryByAiRequest request,
  );
}
