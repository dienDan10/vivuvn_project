import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/network/network_service.dart';
import '../../../itinerary/itinerary-detail/member/data/model/member.dart';
import '../../../itinerary/itinerary-detail/overview/data/dto/hotel_item_response.dart';
import '../../../itinerary/itinerary-detail/overview/data/dto/restaurant_item_response.dart';
import '../../../itinerary/itinerary-detail/schedule/model/itinerary_day.dart';
import '../../../itinerary/itinerary-detail/schedule/model/itinerary_item.dart';
import '../../../itinerary/view-itinerary-list/models/itinerary.dart';

final publicItineraryApiProvider = Provider.autoDispose<PublicItineraryApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return PublicItineraryApi(dio);
});

class PublicItineraryApi {
  final Dio _dio;

  PublicItineraryApi(this._dio);

  /// GET: Get public itinerary detail by id
  /// Endpoint: /api/v1/itineraries/:itineraryId
  Future<Itinerary> getPublicItineraryDetail(final String id) async {
    final response = await _dio.get('/api/v1/itineraries/$id');
    final data = response.data;
    return Itinerary.fromMap(data as Map<String, dynamic>);
  }

  /// GET: Get itinerary days for public itinerary
  Future<List<ItineraryDay>> getItineraryDays(final String itineraryId) async {
    final response = await _dio.get('/api/v1/itineraries/$itineraryId/days');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((final json) => ItineraryDay.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// GET: Get items by day for public itinerary
  Future<List<ItineraryItem>> getItemsByDay(
    final String itineraryId,
    final int dayId,
  ) async {
    final response = await _dio.get(
      '/api/v1/itineraries/$itineraryId/days/$dayId/items',
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((final json) => ItineraryItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET: Get members for public itinerary
  Future<List<Member>> getMembers(final String itineraryId) async {
    final response = await _dio.get('/api/v1/itineraries/$itineraryId/members');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((final e) => Member.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// GET: Get restaurants for public itinerary
  Future<List<RestaurantItemResponse>> getRestaurants(final String itineraryId) async {
    try {
      final response = await _dio.get('/api/v1/itineraries/$itineraryId/restaurants');
      if (response.data == null) return [];
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList
          .map(
            (final json) =>
                RestaurantItemResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// GET: Get hotels for public itinerary
  Future<List<HotelItemResponse>> getHotels(final String itineraryId) async {
    try {
      final response = await _dio.get('/api/v1/itineraries/$itineraryId/hotels');
      if (response.data == null) return [];
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList
          .map(
            (final json) =>
                HotelItemResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }
}

