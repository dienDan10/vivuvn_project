import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/data/remote/network/network_service.dart';
import '../../modal/location.dart';
import '../dto/add_hotel_request.dart';
import '../dto/hotel_item_response.dart';

final hotelsApiProvider = Provider.autoDispose<HotelsApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return HotelsApi(dio);
});

class HotelsApi {
  final Dio _dio;

  HotelsApi(this._dio);

  Future<List<HotelItemResponse>> getHotels(final int itineraryId) async {
    // Get hotels associated with an itinerary
    final response = await _dio.get('/api/v1/itineraries/$itineraryId/hotels');
    if (response.data == null) return [];
    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map(
          (final json) =>
              HotelItemResponse.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<Location>> searchHotels({
    final String textQuery = '',
    final String? provinceName,
  }) async {
    final response = await _dio.get(
      '/api/v1/locations/hotels/search',
      queryParameters: {
        'textQuery': textQuery,
        'provinceName': provinceName ?? '',
      },
    );
    if (response.data == null) return [];
    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map((final json) => Location.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addHotel({
    required final int itineraryId,
    required final AddHotelRequest request,
  }) async {
    await _dio.post(
      '/api/v1/itineraries/$itineraryId/hotels/search',
      data: request.toJson(),
    );
  }

  Future<void> updateHotelNote({
    required final int itineraryId,
    required final String id,
    required final String note,
  }) async {
    // Use PUT if server expects it (405 previously observed for PATCH)
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/hotels/$id/notes',
      data: {'notes': note},
    );
  }

  Future<void> updateHotelDate({
    required final int itineraryId,
    required final String id,
    required final DateTime checkInDate,
    required final DateTime checkOutDate,
  }) async {
    // Use PUT if server expects it (consistent with costs endpoint)
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/hotels/$id/dates',
      data: {
        'checkInDate': checkInDate.toIso8601String(),
        'checkOutDate': checkOutDate.toIso8601String(),
      },
    );
  }

  Future<void> updateHotelCost({
    required final int itineraryId,
    required final String id,
    required final double cost,
  }) async {
    // Server expects PUT for this endpoint (405 returned for PATCH)
    await _dio.put(
      '/api/v1/itineraries/$itineraryId/hotels/$id/costs',
      data: {'cost': cost},
    );
  }

  Future<void> deleteHotel({
    required final int itineraryId,
    required final String id,
  }) async {
    await _dio.delete('/api/v1/itineraries/$itineraryId/hotels/$id');
  }
}
