import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/network/network_service.dart';
import '../dto/register_request.dart';
import '../dto/verify_email_request.dart';

final registerApiProvider = Provider.autoDispose<RegisterApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return RegisterApi(dio);
});

final class RegisterApi {
  final Dio _dio;
  RegisterApi(this._dio);

  Future<void> register(final RegisterRequest request) async {
    await _dio.post('/api/v1/auth/register', data: request.toMap());
  }

  Future<void> verifyEmail(final VerifyEmailRequest request) async {
    await _dio.post('/api/v1/auth/verify-email', data: request.toMap());
  }

  Future<void> resendVerificationEmail(final String email) async {
    await _dio.post('/api/v1/auth/resend-verification', data: {'email': email});
  }
}
