import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../itinerary/itinerary-detail/schedule/model/itinerary_day.dart';
import '../service/public_itinerary_service.dart';
import '../state/public_itinerary_state.dart';

final publicItineraryControllerProvider =
    StateNotifierProvider.autoDispose<PublicItineraryController, PublicItineraryState>(
  (final ref) => PublicItineraryController(ref),
);

class PublicItineraryController extends StateNotifier<PublicItineraryState> {
  final Ref _ref;
  String? _itineraryId;

  PublicItineraryController(this._ref) : super(PublicItineraryState());

  void setItineraryId(final String id) {
    _itineraryId = id;
  }

  Future<void> loadItineraryDetail() async {
    if (_itineraryId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = _ref.read(publicItineraryServiceProvider);
      final itinerary = await service.getPublicItineraryDetail(_itineraryId!);
      final days = await service.getItineraryDays(_itineraryId!);
      final members = await service.getMembers(_itineraryId!);
      final restaurants = await service.getRestaurants(_itineraryId!);
      final hotels = await service.getHotels(_itineraryId!);

      // Load items for each day
      final daysWithItems = <ItineraryDay>[];
      for (final day in days) {
        try {
          final items = await service.getItemsByDay(_itineraryId!, day.id);
          daysWithItems.add(day.copyWith(items: items));
        } catch (e) {
          // If error loading items for a day, use empty list
          daysWithItems.add(day.copyWith(items: []));
        }
      }

      state = state.copyWith(
        itinerary: itinerary,
        days: daysWithItems,
        members: members,
        restaurants: restaurants,
        hotels: hotels,
        isLoading: false,
        selectedDayIndex: daysWithItems.isNotEmpty ? 0 : -1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void selectDay(final int index) {
    if (index >= 0 && index < state.days.length) {
      state = state.copyWith(selectedDayIndex: index);
    }
  }
}

