import '../data/dto/create_itinerary_request.dart';
import '../data/dto/create_itinerary_response.dart';
import '../models/province.dart';

abstract interface class IcreateItineraryService {
  Future<List<Province>> searchProvince(final String queryText);
  Future<CreateItineraryResponse> createItinerary(
    final CreateItineraryRequest request,
  );
}
