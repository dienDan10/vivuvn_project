import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/api/login_api.dart';
import '../data/dto/google_login_request.dart';
import '../data/dto/login_request.dart';
import '../data/dto/login_response.dart';
import 'ilogin_service.dart';

final loginServiceProvider = Provider.autoDispose<ILoginService>((final ref) {
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

  @override
  Future<LoginResponse> loginWithGoogle() async {
    final GoogleSignIn googleSignin = GoogleSignIn.instance;
    await googleSignin.initialize(
      serverClientId: dotenv.env['GOOGLE_CLIENT_ID'] ?? '',
    );

    final GoogleSignInAccount googleUser = await googleSignin
        .authenticate(); // throw if null

    final idToken =
        googleUser.authentication.idToken; // a token that identifies the user

    // Call to backend API to log in with the Google ID token
    final loginRequest = GoogleLoginRequest(idToken: idToken!);

    return await _loginApi.loginWithGoogle(loginRequest);
  }
}
