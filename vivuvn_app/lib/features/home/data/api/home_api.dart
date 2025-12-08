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
  /// GET /itineraries/public?limit=10&sort=recent
  Future<List<ItineraryDto>> getPublicItineraries({
    final int limit = 10,
    final String sort = 'recent',
  }) async {
    // TODO: Implement actual API call when available
    throw UnimplementedError(
      'API endpoint not yet implemented: /api/v1/itineraries/public?limit=$limit&sort=$sort',
    );
  }
}
