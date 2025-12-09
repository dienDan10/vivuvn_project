import '../data/dto/destination_dto.dart';
import '../data/dto/itinerary_dto.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState {
  final HomeStatus status;
  final List<DestinationDto> destinations;
  final List<ItineraryDto> itineraries;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.destinations = const [],
    this.itineraries = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    final HomeStatus? status,
    final List<DestinationDto>? destinations,
    final List<ItineraryDto>? itineraries,
    final String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      destinations: destinations ?? this.destinations,
      itineraries: itineraries ?? this.itineraries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == HomeStatus.loading;
  bool get isLoaded => status == HomeStatus.loaded;
  bool get hasError => status == HomeStatus.error;
  bool get isEmpty => destinations.isEmpty && itineraries.isEmpty;
}
