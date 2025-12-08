import '../dto/destination_dto.dart';
import '../dto/itinerary_dto.dart';

class HomeApi {
  // TODO: Replace with actual API endpoints
  static const String _baseUrl = 'https://api.vivuvietnam.com';
  static const String _destinationsEndpoint = '$_baseUrl/destinations';
  static const String _itinerariesEndpoint = '$_baseUrl/itineraries/public';

  /// Fetch popular destinations
  /// GET /destinations?limit=10
  Future<List<DestinationDto>> getPopularDestinations({
    final int limit = 10,
  }) async {
    // TODO: Implement actual API call
    throw UnimplementedError(
      'API endpoint not yet implemented: $_destinationsEndpoint?limit=$limit',
    );
  }

  /// Fetch public itineraries
  /// GET /itineraries/public?limit=10&sort=recent
  Future<List<ItineraryDto>> getPublicItineraries({
    final int limit = 10,
    final String sort = 'recent',
  }) async {
    // TODO: Implement actual API call
    throw UnimplementedError(
      'API endpoint not yet implemented: $_itinerariesEndpoint?limit=$limit&sort=$sort',
    );
  }
}
