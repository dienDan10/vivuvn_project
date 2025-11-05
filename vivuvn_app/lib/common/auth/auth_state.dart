import '../../features/itinerary/view-itinerary-list/models/user.dart';

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final User? user;

  AuthState({
    this.status = AuthStatus.unknown,
    this.isLoading = false,
    this.user,
  });

  AuthState copyWith({
    final AuthStatus? status,
    final bool? isLoading,
    final User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

enum AuthStatus { unknown, authenticated, unauthenticated }
