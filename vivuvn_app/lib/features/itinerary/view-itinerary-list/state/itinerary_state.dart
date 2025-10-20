import '../models/itinerary.dart';

class ItineraryState {
  final bool isLoading;
  final List<Itinerary> itineraries;
  final String? error;

  ItineraryState({
    this.isLoading = true,
    this.itineraries = const [],
    this.error,
  });

  ItineraryState copyWith({
    final bool? isLoading,
    final List<Itinerary>? itineraries,
    final String? error,
  }) {
    return ItineraryState(
      isLoading: isLoading ?? this.isLoading,
      itineraries: itineraries ?? this.itineraries,
      error: error,
    );
  }
}
