import '../models/province.dart';

class CreateItineraryState {
  final bool isLoading;
  final String? error;
  final Province? startProvince;
  final Province? destinationProvince;
  final DateTime? startDate;
  final DateTime? endDate;

  CreateItineraryState({
    this.isLoading = false,
    this.error,
    this.startProvince,
    this.destinationProvince,
    this.startDate,
    this.endDate,
  });

  CreateItineraryState copyWith({
    final bool? isLoading,
    final String? error,
    final Province? startProvince,
    final Province? destinationProvince,
    final DateTime? startDate,
    final DateTime? endDate,
  }) {
    return CreateItineraryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      startProvince: startProvince ?? this.startProvince,
      destinationProvince: destinationProvince ?? this.destinationProvince,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
