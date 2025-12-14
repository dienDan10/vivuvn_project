import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
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
      final daysWithItems = await Future.wait(
        days.map((final day) async {
          try {
            final items = await service.getItemsByDay(_itineraryId!, day.id);
            return day.copyWith(items: items);
          } catch (_) {
            return day.copyWith(items: []);
          }
        }),
      );

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

  Future<void> joinItinerary() async {
    if (_itineraryId == null) return;
    state = state.copyWith(isJoining: true, error: null);
    try {
      final service = _ref.read(publicItineraryServiceProvider);
      await service.joinPublicItinerary(_itineraryId!);
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleException(e);
      state = state.copyWith(isJoining: false, error: message);
      throw Exception(message);
    } on Exception catch (e) {
      state = state.copyWith(isJoining: false, error: e.toString());
      throw Exception(e.toString());
    } finally {
      state = state.copyWith(isJoining: false);
    }
  }

  Future<int> copyItinerary() async {
    if (_itineraryId == null) {
      throw Exception('Itinerary ID is null');
    }
    state = state.copyWith(isCopying: true, error: null);
    try {
      final service = _ref.read(publicItineraryServiceProvider);
      final newItineraryId = await service.copyPublicItinerary(_itineraryId!);
      return newItineraryId;
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleException(e);
      state = state.copyWith(isCopying: false, error: message);
      throw Exception(message);
    } on Exception catch (e) {
      state = state.copyWith(isCopying: false, error: e.toString());
      throw Exception(e.toString());
    } finally {
      state = state.copyWith(isCopying: false);
    }
  }
}

