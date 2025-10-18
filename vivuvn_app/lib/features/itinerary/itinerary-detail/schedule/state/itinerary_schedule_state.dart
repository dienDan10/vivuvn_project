import '../model/itinerary_day.dart';

class ItineraryScheduleState {
  final int? itineraryId;
  final bool isLoading;
  final String? error;
  final List<ItineraryDay> days;
  final int selectedIndex;

  ItineraryScheduleState({
    this.itineraryId,
    this.isLoading = false,
    this.error,
    this.days = const [],
    this.selectedIndex = 0,
  });

  ItineraryScheduleState copyWith({
    final int? itineraryId,
    final bool? isLoading,
    final String? error,
    final List<ItineraryDay>? days,
    final int? selectedIndex,
  }) {
    return ItineraryScheduleState(
      itineraryId: itineraryId ?? this.itineraryId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      days: days ?? this.days,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
