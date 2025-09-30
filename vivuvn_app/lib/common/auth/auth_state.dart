class AuthState {
  final AuthStatus status;
  final bool isLoading;

  AuthState({this.status = AuthStatus.unknown, this.isLoading = false});

  AuthState copyWith({final AuthStatus? status, final bool? isLoading}) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

enum AuthStatus { unknown, authenticated, unauthenticated }
