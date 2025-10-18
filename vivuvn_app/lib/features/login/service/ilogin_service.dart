import '../data/dto/login_request.dart';
import '../data/dto/login_response.dart';

abstract interface class ILoginService {
  Future<LoginResponse> login(final LoginRequest loginRequest);

  Future<LoginResponse> loginWithGoogle();
}
