class LoginState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic> loginData;

  LoginState({this.isLoading = false, this.error, this.loginData = const {}});

  LoginState copyWith({
    final bool? isLoading,
    final String? error,
    final Map<String, dynamic>? loginData,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      loginData: loginData ?? this.loginData,
    );
  }
}
