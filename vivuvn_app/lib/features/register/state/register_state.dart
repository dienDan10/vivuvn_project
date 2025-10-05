class RegisterState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final Map<String, dynamic> registerData;

  RegisterState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.registerData = const {},
  });

  RegisterState copyWith({
    final bool? isLoading,
    final String? error,
    final bool? isSuccess,
    final Map<String, dynamic>? registerData,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      registerData: registerData ?? this.registerData,
    );
  }
}
