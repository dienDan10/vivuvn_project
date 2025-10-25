import '../model/location_detail.dart';

class LocationState {
  final bool isLoading;
  final String? error;
  final LocationDetail? detail;

  LocationState({this.isLoading = false, this.error, this.detail});

  LocationState copyWith({
    final bool? isLoading,
    final String? error,
    final LocationDetail? detail,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      detail: detail ?? this.detail,
    );
  }
}
