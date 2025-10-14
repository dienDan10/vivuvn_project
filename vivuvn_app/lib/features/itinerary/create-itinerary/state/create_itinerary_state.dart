class CreateItineraryState {
  final bool isLoading;
  final String? error;
  final String startProvinceId;
  final String destinationProvinceId;
  final DateTime? startDate;
  final DateTime? endDate;

  CreateItineraryState({
    this.isLoading = false,
    this.error,
    this.startProvinceId = '',
    this.destinationProvinceId = '',
    this.startDate,
    this.endDate,
  });

  CreateItineraryState copyWith({
    final bool? isLoading,
    final String? error,
    final String? startProvinceId,
    final String? destinationProvinceId,
    final DateTime? startDate,
    final DateTime? endDate,
  }) {
    return CreateItineraryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      startProvinceId: startProvinceId ?? this.startProvinceId,
      destinationProvinceId:
          destinationProvinceId ?? this.destinationProvinceId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
