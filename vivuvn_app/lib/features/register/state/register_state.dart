class RegisterState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic> registerData;
  final String? emailError;

  RegisterState({
    this.isLoading = false,
    this.error,
    this.registerData = const {},
    this.emailError,
  });

  RegisterState copyWith({
    final bool? isLoading,
    final String? error,
    final Map<String, dynamic>? registerData,
    final String? emailError,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      registerData: registerData ?? this.registerData,
      emailError: emailError ?? this.emailError,
    );
  }
}
