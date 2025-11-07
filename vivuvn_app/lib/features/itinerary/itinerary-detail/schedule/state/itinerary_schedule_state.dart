import '../model/itinerary_day.dart';
import '../model/itinerary_item.dart';
import '../model/location.dart';

class ItineraryScheduleState {
  final int? itineraryId;
  final bool isLoading;
  final bool isLoadingUpdateTransportation;
  final bool isLoadingSuggestedLocations;
  final String? error;
  final String? updateTransportationError;
  final String? suggestedLocationsError;
  final List<ItineraryDay> days;
  final List<Location> suggestedLocations;
  final int selectedIndex;
  final int? selectedDayId;
  final int? suggestedProvinceId;

  ItineraryScheduleState({
    this.itineraryId,
    this.isLoading = false,
    this.isLoadingUpdateTransportation = false,
    this.isLoadingSuggestedLocations = false,
    this.error,
    this.updateTransportationError,
    this.suggestedLocationsError,
    this.days = const [],
    this.suggestedLocations = const [],
    this.selectedIndex = 0,
    this.selectedDayId,
    this.suggestedProvinceId,
  });

  ItineraryScheduleState copyWith({
    final int? itineraryId,
    final bool? isLoading,
    final bool? isLoadingUpdateTransportation,
    final bool? isLoadingSuggestedLocations,
    final String? error,
    final String? updateTransportationError,
    final String? suggestedLocationsError,
    final List<ItineraryDay>? days,
    final List<Location>? suggestedLocations,
    final int? selectedIndex,
    final ItineraryItem? selectedItem,
    final int? selectedDayId,
    final int? suggestedProvinceId,
  }) {
    return ItineraryScheduleState(
      itineraryId: itineraryId ?? this.itineraryId,
      isLoading: isLoading ?? this.isLoading,
      isLoadingUpdateTransportation:
          isLoadingUpdateTransportation ?? this.isLoadingUpdateTransportation,
      isLoadingSuggestedLocations:
          isLoadingSuggestedLocations ?? this.isLoadingSuggestedLocations,
      error: error,
      updateTransportationError: updateTransportationError,
      suggestedLocationsError: suggestedLocationsError,
      days: days ?? this.days,
      suggestedLocations: suggestedLocations ?? this.suggestedLocations,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedDayId: selectedDayId ?? this.selectedDayId,
      suggestedProvinceId: suggestedProvinceId ?? this.suggestedProvinceId,
    );
  }
}
