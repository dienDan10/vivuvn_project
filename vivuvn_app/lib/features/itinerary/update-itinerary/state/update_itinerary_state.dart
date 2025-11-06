// Sentinel for nullable fields in copyWith
const Object _noValue = Object();

class UpdateItineraryState {
  final int? itineraryId;
  final bool isLoading;
  final String? error;

  // Optional local mirrors for UI convenience
  final String? lastUpdatedName;
  final bool? isPublic; // null if unknown
  
  // Track optimistic updates for privacy status per itinerary
  final Map<int, bool> optimisticIsPublicMap;

  UpdateItineraryState({
    this.itineraryId,
    this.isLoading = false,
    this.error,
    this.lastUpdatedName,
    this.isPublic,
    final Map<int, bool>? optimisticIsPublicMap,
  }) : optimisticIsPublicMap = optimisticIsPublicMap ?? {};

  UpdateItineraryState copyWith({
    final int? itineraryId,
    final bool? isLoading,
    final Object? error = _noValue,
    final Object? lastUpdatedName = _noValue,
    final Object? isPublic = _noValue,
    final Map<int, bool>? optimisticIsPublicMap,
  }) {
    return UpdateItineraryState(
      itineraryId: itineraryId ?? this.itineraryId,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _noValue) ? this.error : error as String?,
      lastUpdatedName: identical(lastUpdatedName, _noValue)
          ? this.lastUpdatedName
          : lastUpdatedName as String?,
      isPublic: identical(isPublic, _noValue)
          ? this.isPublic
          : isPublic as bool?,
      optimisticIsPublicMap: optimisticIsPublicMap ?? this.optimisticIsPublicMap,
    );
  }
}


