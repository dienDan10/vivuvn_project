class ExpenseBillState {
  final List<String> localImagePaths;
  final bool isPicking;
  final String? error;
  final bool isSavingToGallery;

  const ExpenseBillState({
    this.localImagePaths = const [],
    this.isPicking = false,
    this.error,
    this.isSavingToGallery = false,
  });

  ExpenseBillState copyWith({
    final List<String>? localImagePaths,
    final bool? isPicking,
    final String? error,
    final bool? isSavingToGallery,
  }) {
    return ExpenseBillState(
      localImagePaths: localImagePaths ?? this.localImagePaths,
      isPicking: isPicking ?? this.isPicking,
      error: error,
      isSavingToGallery: isSavingToGallery ?? this.isSavingToGallery,
    );
  }
}


