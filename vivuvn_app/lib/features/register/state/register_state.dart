class RegisterState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic> registerData;

  RegisterState({
    this.isLoading = false,
    this.error,
    this.registerData = const {},
  });

  RegisterState copyWith({
    final bool? isLoading,
    final String? error,
    final Map<String, dynamic>? registerData,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      registerData: registerData ?? this.registerData,
    );
  }
}
