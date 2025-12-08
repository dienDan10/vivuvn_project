import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/home_api.dart';
import '../data/dto/destination_dto.dart';
import '../data/dto/itinerary_dto.dart';
import 'home_service.dart';

final homeServiceProvider = Provider<HomeService>((final ref) {
  final api = ref.watch(homeApiProvider);
  return HomeServiceImpl(api: api);
});

class HomeServiceImpl implements HomeService {
  final HomeApi _api;

  HomeServiceImpl({required final HomeApi api}) : _api = api;

  @override
  Future<List<DestinationDto>> getPopularDestinations() async {
    try {
      return await _api.getPopularDestinations(limit: 5);
    } catch (e) {
      debugPrint('Error fetching destinations: $e');
      rethrow;
    }
  }

  @override
  Future<List<ItineraryDto>> getPublicItineraries() async {
    try {
      return await _api.getPublicItineraries(
        page: 1,
        pageSize: 5,
        sortByDate: true,
        isDescending: false,
      );
    } catch (e) {
      debugPrint('Error fetching itineraries: $e');
      rethrow;
    }
  }
}
