import '../data/dto/search_location_response.dart';

abstract interface class ISearchLocationService {
  Future<List<SearchLocationResponse>> searchLocation(final String query);
}
