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
      // TODO: Replace with actual API call when available
      // return await _api.getPublicItineraries(limit: 10, sort: 'recent');

      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockItineraries();
    } catch (e) {
      debugPrint('Error fetching itineraries: $e');
      rethrow;
    }
  }


  List<ItineraryDto> _generateMockItineraries() {
    return List.generate(
      3,
      (final index) => ItineraryDto(
        id: 'itinerary_$index',
        title: 'Lịch trình ${index + 1}',
        destination: 'Điểm đến ${index + 1}',
        imageUrl:
            'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&h=400&fit=crop',
        startDate: DateTime.now().add(Duration(days: index * 7)),
        endDate: DateTime.now().add(Duration(days: (index * 7) + 3)),
        participantCount: 5 + (index * 2),
        durationDays: 3,
        isPublic: true,
        owner: OwnerDto(
          id: 'user_$index',
          name: 'Người dùng ${index + 1}',
          avatarUrl: null,
        ),
      ),
    );
  }
}
