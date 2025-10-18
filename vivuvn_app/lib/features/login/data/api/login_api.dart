import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/network/network_service.dart';
import '../dto/google_login_request.dart';
import '../dto/login_request.dart';
import '../dto/login_response.dart';

final loginApiProvider = Provider.autoDispose<LoginApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return LoginApi(dio);
});

final class LoginApi {
  final Dio _dio;

  LoginApi(this._dio);

  Future<LoginResponse> login(final LoginRequest loginRequest) async {
    final response = await _dio.post(
      '/api/v1/auth/login',
      data: loginRequest.toMap(),
    );

    return LoginResponse.fromMap(response.data);
  }

  Future<LoginResponse> loginWithGoogle(
    final GoogleLoginRequest request,
  ) async {
    final response = await _dio.post(
      '/api/v1/auth/google-login',
      data: request.toJson(),
    );

    return LoginResponse.fromMap(response.data);
  }
}
