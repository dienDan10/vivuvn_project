import '../data/dto/hotel_item_response.dart';

class HotelsState {
  final bool isLoading;
  final List<HotelItemResponse> hotels;
  final String? error;
  final int? itineraryId;
  final String? savingHotelId;
  final HotelSavingType? savingType;

  HotelsState({
    this.isLoading = false,
    this.hotels = const [],
    this.error,
    this.itineraryId,
    this.savingHotelId,
    this.savingType,
  });

  HotelsState copyWith({
    final bool? isLoading,
    final List<HotelItemResponse>? hotels,
    final String? error,
    final int? itineraryId,
    final String? savingHotelId,
    final HotelSavingType? savingType,
  }) {
    return HotelsState(
      isLoading: isLoading ?? this.isLoading,
      hotels: hotels ?? this.hotels,
      error: error,
      itineraryId: itineraryId ?? this.itineraryId,
      savingHotelId: savingHotelId,
      savingType: savingType,
    );
  }

  bool isSaving(String hotelId, HotelSavingType type) {
    return savingHotelId == hotelId && savingType == type;
  }

  bool isAnySaving(String hotelId) {
    return savingHotelId == hotelId;
  }
}

enum HotelSavingType {
  cost,
  note,
  dates,
}
