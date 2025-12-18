import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../service/public_itinerary_service.dart';
import '../state/public_itinerary_state.dart';

final publicItineraryControllerProvider =
    StateNotifierProvider.autoDispose<
      PublicItineraryController,
      PublicItineraryState
    >((final ref) => PublicItineraryController(ref));

class PublicItineraryController extends StateNotifier<PublicItineraryState> {
  final Ref _ref;
  String? _itineraryId;
  int? _prefetchedMemberCount;

  PublicItineraryController(this._ref) : super(PublicItineraryState());

  void setItineraryId(final String id) {
    _itineraryId = id;
  }

  void setPrefetchedMemberCount(final int count) {
    _prefetchedMemberCount = count;
  }

  Future<void> loadItineraryDetail() async {
    if (_itineraryId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = _ref.read(publicItineraryServiceProvider);
      final itinerary = await service.getPublicItineraryDetail(_itineraryId!);
      final days = await service.getItineraryDays(_itineraryId!);
      final restaurants = await service.getRestaurants(_itineraryId!);
      final hotels = await service.getHotels(_itineraryId!);

      final patchedItinerary = itinerary.copyWith(
        currentMemberCount:
            _prefetchedMemberCount ?? itinerary.currentMemberCount,
      );
      _prefetchedMemberCount = null;

      state = state.copyWith(
        itinerary: patchedItinerary,
        // days đã bao gồm items => không gọi thêm API items
        days: days,
        // Bỏ gọi API members vì detail đã chứa isMember/isOwner; giữ rỗng để tránh request thừa.
        members: const [],
        restaurants: restaurants,
        hotels: hotels,
        isLoading: false,
        selectedDayIndex: days.isNotEmpty ? 0 : -1,
      );
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleException(e);
      state = state.copyWith(isLoading: false, error: message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
