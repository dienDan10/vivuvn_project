import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../itinerary/itinerary-detail/member/data/model/member.dart';
import '../../itinerary/itinerary-detail/overview/data/dto/hotel_item_response.dart';
import '../../itinerary/itinerary-detail/overview/data/dto/restaurant_item_response.dart';
import '../../itinerary/itinerary-detail/schedule/model/itinerary_day.dart';
import '../../itinerary/itinerary-detail/schedule/model/itinerary_item.dart';
import '../../itinerary/view-itinerary-list/models/itinerary.dart';
import '../data/api/public_itinerary_api.dart';

final publicItineraryServiceProvider =
    Provider.autoDispose<PublicItineraryService>((final ref) {
  final api = ref.watch(publicItineraryApiProvider);
  return PublicItineraryService(api);
});

class PublicItineraryService {
  final PublicItineraryApi _api;

  PublicItineraryService(this._api);

  Future<Itinerary> getPublicItineraryDetail(final String id) async {
    return await _api.getPublicItineraryDetail(id);
  }

  Future<List<ItineraryDay>> getItineraryDays(final String itineraryId) async {
    return await _api.getItineraryDays(itineraryId);
  }

  Future<List<ItineraryItem>> getItemsByDay(
    final String itineraryId,
    final int dayId,
  ) async {
    return await _api.getItemsByDay(itineraryId, dayId);
  }

  Future<List<Member>> getMembers(final String itineraryId) async {
    return await _api.getMembers(itineraryId);
  }

  Future<List<RestaurantItemResponse>> getRestaurants(final String itineraryId) async {
    return await _api.getRestaurants(itineraryId);
  }

  Future<List<HotelItemResponse>> getHotels(final String itineraryId) async {
    return await _api.getHotels(itineraryId);
  }

  Future<void> joinPublicItinerary(final String itineraryId) async {
    await _api.joinPublicItinerary(itineraryId);
  }
}

