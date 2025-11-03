class JoinItineraryState {
  final bool isLoading;
  final String? error;
  final String inviteCode;
  final String? pickedImagePath;
  final bool isScanHandled;

  JoinItineraryState({
    this.isLoading = false,
    this.error,
    this.inviteCode = '',
    this.pickedImagePath,
    this.isScanHandled = false,
  });

  JoinItineraryState copyWith({
    final bool? isLoading,
    final String? error,
    final String? inviteCode,
    final String? pickedImagePath,
    final bool? isScanHandled,
  }) {
    return JoinItineraryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      inviteCode: inviteCode ?? this.inviteCode,
      pickedImagePath: pickedImagePath ?? this.pickedImagePath,
      isScanHandled: isScanHandled ?? this.isScanHandled,
    );
  }
}


