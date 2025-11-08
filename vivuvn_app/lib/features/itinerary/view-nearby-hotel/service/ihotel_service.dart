import '../data/model/hotel.dart';

abstract interface class IHotelService {
  Future<List<Hotel>> fetchNearbyHotels(final int locationId);
  Future<void> addHotelToItinerary(final int hotelId, final int itineraryId);
}
