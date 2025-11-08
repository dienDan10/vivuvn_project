import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/hotel_api.dart';
import '../data/dto/add_hotel_to_itinerary_request.dart';
import '../data/model/hotel.dart';
import 'ihotel_service.dart';

class HotelService implements IHotelService {
  final HotelApi _hotelApi;

  HotelService(this._hotelApi);

  @override
  Future<List<Hotel>> fetchNearbyHotels(final int locationId) async {
    return await _hotelApi.fetchNearbyHotels(locationId);
  }

  @override
  Future<void> addHotelToItinerary(
    final int hotelId,
    final int itineraryId,
  ) async {
    final request = AddHotelToItineraryRequest(hotelId: hotelId);
    await _hotelApi.addHotelToItinerary(itineraryId, request);
  }
}

final hotelServiceProvider = Provider.autoDispose<IHotelService>((final ref) {
  final hotelApi = ref.watch(hotelApiProvider);
  return HotelService(hotelApi);
});
