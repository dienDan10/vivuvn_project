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
      rethrow;
    }
  }

  @override
  Future<List<ItineraryDto>> getPublicItineraries({
    final int page = 1,
    final int pageSize = 5,
    final bool sortByDate = true,
    final bool isDescending = false,
    final int? provinceId,
  }) async {
    try {
      return await _api.getPublicItineraries(
        page: page,
        pageSize: pageSize,
        sortByDate: sortByDate,
        isDescending: isDescending,
        provinceId: provinceId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
