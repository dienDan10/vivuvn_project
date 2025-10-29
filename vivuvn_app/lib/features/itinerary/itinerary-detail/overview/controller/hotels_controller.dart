import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../controller/itinerary_detail_controller.dart';
import '../data/dto/add_hotel_request.dart';
import '../modal/location.dart';
import '../services/hotels_service.dart';
import '../state/hotels_state.dart';

final hotelsControllerProvider =
    AutoDisposeNotifierProvider<HotelsController, HotelsState>(
      () => HotelsController(),
    );

class HotelsController extends AutoDisposeNotifier<HotelsState> {
  @override
  HotelsState build() {
    // Auto-load hotels when controller is first created and itineraryId is available
    final itineraryId = ref.watch(
      itineraryDetailControllerProvider.select((final s) => s.itineraryId),
    );

    if (itineraryId != null) {
      // Schedule load for next microtask to avoid modifying state during build
      Future.microtask(() => loadHotels(itineraryId));
    }

    return HotelsState();
  }

  Future<void> loadHotels(final int? itineraryId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      itineraryId: itineraryId,
    );
    try {
      final service = ref.read(hotelsServiceProvider);
      final hotels = await service.getHotels(itineraryId!);
      state = state.copyWith(hotels: hotels, isLoading: false);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg, isLoading: false);
    } catch (_) {
      state = state.copyWith(error: 'Unknown error', isLoading: false);
    }
  }

  Future<List<Location>> searchHotels(final String textQuery) async {
    final service = ref.read(hotelsServiceProvider);
    final provinceName = ref
        .read(itineraryDetailControllerProvider)
        .itinerary
        ?.destinationProvinceName;
    return await service.searchHotels(
      textQuery: textQuery,
      provinceName: provinceName,
    );
  }

  Future<bool> addHotel({
    required final String googlePlaceId,
    required final DateTime checkInDate,
    required final DateTime checkOutDate,
    final String? imageUrl,
  }) async {
    try {
      final service = ref.read(hotelsServiceProvider);
      final checkIn = DateFormat('yyyy-MM-dd').format(checkInDate);
      final checkOut = DateFormat('yyyy-MM-dd').format(checkOutDate);
      final request = AddHotelRequest(
        googlePlaceId: googlePlaceId,
        checkIn: checkIn,
        checkOut: checkOut,
      );
      // Resolve itineraryId from state or from itinerary detail controller
      final int? itineraryId =
          state.itineraryId ??
          ref.read(itineraryDetailControllerProvider).itineraryId;
      if (itineraryId == null) {
        state = state.copyWith(error: 'Itinerary ID not set');
        return false;
      }
      await service.addHotel(itineraryId: itineraryId, request: request);
      await loadHotels(itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> updateHotelDate({
    required final String id,
    required final DateTime checkInDate,
    required final DateTime checkOutDate,
  }) async {
    try {
      final service = ref.read(hotelsServiceProvider);
      await service.updateHotelDate(
        itineraryId: state.itineraryId!,
        id: id,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
      );
      await loadHotels(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> updateHotelNote({
    required final String id,
    required final String note,
  }) async {
    try {
      final service = ref.read(hotelsServiceProvider);
      await service.updateHotelNote(
        itineraryId: state.itineraryId!,
        id: id,
        note: note,
      );
      await loadHotels(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> updateHotelCost({
    required final String id,
    required final double cost,
  }) async {
    try {
      final service = ref.read(hotelsServiceProvider);
      await service.updateHotelCost(
        itineraryId: state.itineraryId!,
        id: id,
        cost: cost,
      );
      await loadHotels(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  Future<bool> removeHotel(final String id) async {
    try {
      final service = ref.read(hotelsServiceProvider);
      await service.deleteHotel(itineraryId: state.itineraryId!, id: id);
      await loadHotels(state.itineraryId);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errorMsg);
      return false;
    } catch (_) {
      state = state.copyWith(error: 'Unknown error');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
