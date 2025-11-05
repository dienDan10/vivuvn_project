import '../model/itinerary_day.dart';
import '../model/itinerary_item.dart';

class ItineraryScheduleState {
  final int? itineraryId;
  final bool isLoading;
  final bool isLoadingUpdateTransportation;
  final String? error;
  final String? updateTransportationError;
  final List<ItineraryDay> days;
  final int selectedIndex;
  final int? selectedDayId;

  ItineraryScheduleState({
    this.itineraryId,
    this.isLoading = false,
    this.isLoadingUpdateTransportation = false,
    this.error,
    this.updateTransportationError,
    this.days = const [],
    this.selectedIndex = 0,
    this.selectedDayId,
  });

  ItineraryScheduleState copyWith({
    final int? itineraryId,
    final bool? isLoading,
    final bool? isLoadingUpdateTransportation,
    final String? error,
    final String? updateTransportationError,
    final List<ItineraryDay>? days,
    final int? selectedIndex,
    final ItineraryItem? selectedItem,
    final int? selectedDayId,
  }) {
    return ItineraryScheduleState(
      itineraryId: itineraryId ?? this.itineraryId,
      isLoading: isLoading ?? this.isLoading,
      isLoadingUpdateTransportation:
          isLoadingUpdateTransportation ?? this.isLoadingUpdateTransportation,
      error: error,
      updateTransportationError: updateTransportationError,
      days: days ?? this.days,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedDayId: selectedDayId ?? this.selectedDayId,
    );
  }
}
