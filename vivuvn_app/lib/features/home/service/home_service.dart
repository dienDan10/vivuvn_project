import '../data/dto/destination_dto.dart';
import '../data/dto/itinerary_dto.dart';

abstract class HomeService {
  /// Fetch popular destinations
  Future<List<DestinationDto>> getPopularDestinations();

  /// Fetch public itineraries
  Future<List<ItineraryDto>> getPublicItineraries();
}
