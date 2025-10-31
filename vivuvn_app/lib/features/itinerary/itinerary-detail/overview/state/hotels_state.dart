import '../data/dto/hotel_item_response.dart';
import '../models/location.dart';

class _Unset {
  const _Unset();
}

class HotelsState {
  // Sentinel to allow copyWith to distinguish between "not provided" and explicit null
  static const _Unset _unset = _Unset();
  final bool isLoading;
  final List<HotelItemResponse> hotels;
  final String? error;
  final int? itineraryId;
  final String? savingHotelId;
  final HotelSavingType? savingType;

  // Add hotel form fields
  final Location? formSelectedLocation;
  final DateTime? formCheckInDate;
  final DateTime? formCheckOutDate;
  // Edit is handled inline on hotel cards, not via this form state

  HotelsState({
    this.isLoading = false,
    this.hotels = const [],
    this.error,
    this.itineraryId,
    this.savingHotelId,
    this.savingType,
    this.formSelectedLocation,
    this.formCheckInDate,
    this.formCheckOutDate,
  });

  HotelsState copyWith({
    final bool? isLoading,
    final List<HotelItemResponse>? hotels,
    final String? error,
    final Object? itineraryId = _unset,
    final Object? savingHotelId = _unset,
    final Object? savingType = _unset,
    final Object? formSelectedLocation = _unset,
    final Object? formCheckInDate = _unset,
    final Object? formCheckOutDate = _unset,
    final Object? formHotelToEdit = _unset, // deprecated
    final bool? formIsEditMode, // deprecated
  }) {
    return HotelsState(
      isLoading: isLoading ?? this.isLoading,
      hotels: hotels ?? this.hotels,
      error: error,
      itineraryId: identical(itineraryId, _unset)
          ? this.itineraryId
          : itineraryId as int?,
      savingHotelId: identical(savingHotelId, _unset)
          ? this.savingHotelId
          : savingHotelId as String?,
      savingType: identical(savingType, _unset)
          ? this.savingType
          : savingType as HotelSavingType?,
      formSelectedLocation: identical(formSelectedLocation, _unset)
          ? this.formSelectedLocation
          : formSelectedLocation as Location?,
      formCheckInDate: identical(formCheckInDate, _unset)
          ? this.formCheckInDate
          : formCheckInDate as DateTime?,
      formCheckOutDate: identical(formCheckOutDate, _unset)
          ? this.formCheckOutDate
          : formCheckOutDate as DateTime?,
    );
  }

  bool isSaving(String hotelId, HotelSavingType type) {
    return savingHotelId == hotelId && savingType == type;
  }

  bool isAnySaving(String hotelId) {
    return savingHotelId == hotelId;
  }

  // Form helpers
  bool get formIsValid => formSelectedLocation != null;

  String get formDisplayName => formSelectedLocation?.name ?? '';
}

enum HotelSavingType { cost, note, dates }
