/// State for image loading timeout
class ImageTimeoutState {
  final bool timedOut;

  const ImageTimeoutState({
    this.timedOut = false,
  });

  ImageTimeoutState copyWith({
    bool? timedOut,
  }) {
    return ImageTimeoutState(
      timedOut: timedOut ?? this.timedOut,
    );
  }
}
