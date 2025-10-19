import '../../view-itinerary-list/models/itinerary.dart';

class ItineraryDetailState {
  final int? itineraryId;
  final bool isLoading;
  final Itinerary? itinerary;
  final String? error;

  ItineraryDetailState({
    this.itineraryId,
    this.isLoading = false,
    this.itinerary,
    this.error,
  });

  ItineraryDetailState copyWith({
    final int? itineraryId,
    final bool? isLoading,
    final Itinerary? itinerary,
    final String? error,
  }) {
    return ItineraryDetailState(
      itineraryId: itineraryId ?? this.itineraryId,
      isLoading: isLoading ?? this.isLoading,
      itinerary: itinerary ?? this.itinerary,
      error: error,
    );
  }
}
