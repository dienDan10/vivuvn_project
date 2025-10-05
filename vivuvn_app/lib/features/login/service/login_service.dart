import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/login_api.dart';
import '../data/dto/login_request.dart';
import '../data/dto/login_response.dart';
import 'ilogin_service.dart';

final loginServiceProvider = Provider<ILoginService>((final ref) {
  final loginApi = ref.watch(loginApiProvider);
  return LoginService(loginApi);
});

final class LoginService implements ILoginService {
  final LoginApi _loginApi;
  LoginService(this._loginApi);

  @override
  Future<LoginResponse> login(final LoginRequest loginRequest) async {
    return await _loginApi.login(loginRequest);
  }
}
