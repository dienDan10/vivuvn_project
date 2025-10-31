import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../detail/controller/itinerary_detail_controller.dart';
import '../data/dto/add_hotel_request.dart';
import '../models/location.dart';
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
      initializeForm();
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
    state = state.copyWith(
      savingHotelId: id,
      savingType: HotelSavingType.dates,
    );
    try {
      final service = ref.read(hotelsServiceProvider);
      await service.updateHotelDate(
        itineraryId: state.itineraryId!,
        id: id,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
      );
      await loadHotels(state.itineraryId);
      state = state.copyWith(savingHotelId: null, savingType: null);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        error: errorMsg,
        savingHotelId: null,
        savingType: null,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        error: 'Unknown error',
        savingHotelId: null,
        savingType: null,
      );
      return false;
    }
  }

  Future<bool> updateHotelNote({
    required final String id,
    required final String note,
  }) async {
    state = state.copyWith(savingHotelId: id, savingType: HotelSavingType.note);
    try {
      final service = ref.read(hotelsServiceProvider);
      await service.updateHotelNote(
        itineraryId: state.itineraryId!,
        id: id,
        note: note,
      );
      await loadHotels(state.itineraryId);
      state = state.copyWith(savingHotelId: null, savingType: null);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        error: errorMsg,
        savingHotelId: null,
        savingType: null,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        error: 'Unknown error',
        savingHotelId: null,
        savingType: null,
      );
      return false;
    }
  }

  Future<bool> updateHotelCost({
    required final String id,
    required final double cost,
  }) async {
    state = state.copyWith(savingHotelId: id, savingType: HotelSavingType.cost);
    try {
      final service = ref.read(hotelsServiceProvider);
      await service.updateHotelCost(
        itineraryId: state.itineraryId!,
        id: id,
        cost: cost,
      );
      await loadHotels(state.itineraryId);
      state = state.copyWith(savingHotelId: null, savingType: null);
      return true;
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        error: errorMsg,
        savingHotelId: null,
        savingType: null,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        error: 'Unknown error',
        savingHotelId: null,
        savingType: null,
      );
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

  // Form methods
  void initializeForm() {
    state = state.copyWith(
      formSelectedLocation: null,
      formCheckInDate: DateTime.now(),
      formCheckOutDate: DateTime.now(),
    );
  }

  void setFormLocation(final Location location) {
    state = state.copyWith(formSelectedLocation: location);
  }

  void setFormCheckInDate(final DateTime date) {
    state = state.copyWith(formCheckInDate: date);

    // Auto adjust check-out if it's before check-in
    if (state.formCheckOutDate != null &&
        state.formCheckOutDate!.isBefore(date)) {
      state = state.copyWith(
        formCheckOutDate: date.add(const Duration(days: 1)),
      );
    }
  }

  void setFormCheckOutDate(final DateTime date) {
    state = state.copyWith(formCheckOutDate: date);
  }

  Future<bool> saveForm() async {
    if (state.formDisplayName.isEmpty) return false;

    // Add new hotel — requires googlePlaceId and date values
    final googlePlaceId = state.formSelectedLocation?.googlePlaceId;
    if (googlePlaceId == null) return false;

    return await addHotel(
      googlePlaceId: googlePlaceId,
      checkInDate: state.formCheckInDate ?? DateTime.now(),
      checkOutDate:
          state.formCheckOutDate ?? state.formCheckInDate ?? DateTime.now(),
    );
  }

  void resetForm() {
    state = state.copyWith(
      formSelectedLocation: null,
      formCheckInDate: null,
      formCheckOutDate: null,
    );
  }
}
