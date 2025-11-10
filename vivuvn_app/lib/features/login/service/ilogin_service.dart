import '../data/dto/login_request.dart';
import '../data/dto/login_response.dart';

abstract interface class ILoginService {
  Future<LoginResponse> login(final LoginRequest loginRequest);

  Future<LoginResponse> loginWithGoogle();

  Future<void> forgotPassword(final String email);

  Future<void> resetPassword(
    final String email,
    final String newPassword,
    final String token,
  );
}
