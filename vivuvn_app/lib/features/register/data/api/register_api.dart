import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/network/network_service.dart';
import '../dto/register_request.dart';
import '../dto/register_response.dart';

final registerApiProvider = Provider<RegisterApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return RegisterApi(dio);
});

final class RegisterApi {
  final Dio _dio;
  RegisterApi(this._dio);

  Future<RegisterResponse> register(final RegisterRequest request) async {
    final response = await _dio.post(
      '/api/v1/auth/register',
      data: request.toMap(),
    );
    return RegisterResponse.fromMap(response.data);
  }
}
