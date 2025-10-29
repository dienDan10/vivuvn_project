import '../data/dto/hotel_item_response.dart';

class HotelsState {
  final bool isLoading;
  final List<HotelItemResponse> hotels;
  final String? error;
  final int? itineraryId;

  HotelsState({
    this.isLoading = false,
    this.hotels = const [],
    this.error,
    this.itineraryId,
  });

  HotelsState copyWith({
    final bool? isLoading,
    final List<HotelItemResponse>? hotels,
    final String? error,
    final int? itineraryId,
  }) {
    return HotelsState(
      isLoading: isLoading ?? this.isLoading,
      hotels: hotels ?? this.hotels,
      error: error,
      itineraryId: itineraryId ?? this.itineraryId,
    );
  }
}
