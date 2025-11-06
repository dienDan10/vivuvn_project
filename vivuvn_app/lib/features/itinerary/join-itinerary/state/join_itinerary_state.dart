class JoinItineraryState {
  final bool isLoading;
  final String? error;
  final String inviteCode;
  final String? pickedImagePath;
  final bool isScanHandled;
  final bool isDecodingImage;

  JoinItineraryState({
    this.isLoading = false,
    this.error,
    this.inviteCode = '',
    this.pickedImagePath,
    this.isScanHandled = false,
    this.isDecodingImage = false,
  });

  JoinItineraryState copyWith({
    final bool? isLoading,
    final String? error,
    final String? inviteCode,
    final String? pickedImagePath,
    final bool? isScanHandled,
    final bool? isDecodingImage,
  }) {
    return JoinItineraryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      inviteCode: inviteCode ?? this.inviteCode,
      pickedImagePath: pickedImagePath ?? this.pickedImagePath,
      isScanHandled: isScanHandled ?? this.isScanHandled,
      isDecodingImage: isDecodingImage ?? this.isDecodingImage,
    );
  }
}


