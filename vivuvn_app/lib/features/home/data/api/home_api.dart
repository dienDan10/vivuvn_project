import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/network/network_service.dart';
import '../dto/destination_dto.dart';
import '../dto/itinerary_dto.dart';

final homeApiProvider = Provider.autoDispose<HomeApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return HomeApi(dio);
});

class HomeApi {
  final Dio _dio;

  HomeApi(this._dio);

  /// Fetch popular destinations
  /// GET /api/v1/locations/top-travel-locations?limit=5
  Future<List<DestinationDto>> getPopularDestinations({
    final int limit = 5,
  }) async {
    final response = await _dio.get(
      '/api/v1/locations/top-travel-locations',
      queryParameters: {'limit': limit},
    );

    if (response.data == null) return [];

    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList
        .map((final json) => DestinationDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch public itineraries
  /// GET /api/v1/itineraries/public?page=1&pageSize=5&sortByDate=true&isDescending=false
  Future<List<ItineraryDto>> getPublicItineraries({
    final int page = 1,
    final int pageSize = 5,
    final bool sortByDate = true,
    final bool isDescending = false,
  }) async {
    final response = await _dio.get(
      '/api/v1/itineraries/public',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'sortByDate': sortByDate,
        'isDescending': isDescending,
      },
    );

    if (response.data == null) return [];

    // Handle both array response and paginated response with 'data' field
    List<dynamic> jsonList;
    if (response.data is List) {
      jsonList = response.data as List<dynamic>;
    } else if (response.data is Map && (response.data as Map).containsKey('data')) {
      jsonList = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    } else {
      return [];
    }

    return jsonList
        .map((final json) => ItineraryDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
