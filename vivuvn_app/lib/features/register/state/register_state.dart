class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final bool isEmailVerified;
  final String? error;
  final Map<String, String> registerData;

  const RegisterState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isEmailVerified = false,
    this.error,
    this.registerData = const {},
  });

  RegisterState copyWith({
    final bool? isLoading,
    final bool? isSuccess,
    final bool? isEmailVerified,
    final String? error,
    final Map<String, String>? registerData,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      error: error,
      registerData: registerData ?? this.registerData,
    );
  }
}
