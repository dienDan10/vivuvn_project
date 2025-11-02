import '../model/hotel.dart';

abstract interface class IHotelService {
  Future<List<Hotel>> fetchNearbyHotels(final int locationId);
}
