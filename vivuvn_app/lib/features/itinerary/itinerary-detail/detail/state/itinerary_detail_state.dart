import '../../../view-itinerary-list/models/itinerary.dart';

// Sentinel to allow copyWith to distinguish between "not provided" and "explicit null"
const Object _noValue = Object();

class ItineraryDetailState {
  final int? itineraryId;
  final bool isLoading;
  final Itinerary? itinerary;
  final String? error;
  // Group size inline edit state
  final bool isGroupSizeEditing;
  final bool isGroupSizeSaving;
  final int? groupSizeDraft;

  ItineraryDetailState({
    this.itineraryId,
    this.isLoading = false,
    this.itinerary,
    this.error,
    this.isGroupSizeEditing = false,
    this.isGroupSizeSaving = false,
    this.groupSizeDraft,
  });

  ItineraryDetailState copyWith({
    final int? itineraryId,
    final bool? isLoading,
    final Itinerary? itinerary,
    final String? error,
    final bool? isGroupSizeEditing,
    final bool? isGroupSizeSaving,
    final Object? groupSizeDraft = _noValue,
  }) {
    return ItineraryDetailState(
      itineraryId: itineraryId ?? this.itineraryId,
      isLoading: isLoading ?? this.isLoading,
      itinerary: itinerary ?? this.itinerary,
      error: error,
      isGroupSizeEditing: isGroupSizeEditing ?? this.isGroupSizeEditing,
      isGroupSizeSaving: isGroupSizeSaving ?? this.isGroupSizeSaving,
      groupSizeDraft: identical(groupSizeDraft, _noValue)
          ? this.groupSizeDraft
          : groupSizeDraft as int?,
    );
  }
}
