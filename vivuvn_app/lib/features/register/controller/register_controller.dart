import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dto/register_request.dart';
import '../service/register_service.dart';
import '../state/register_state.dart';

final registerControllerProvider =
    AutoDisposeNotifierProvider<RegisterController, RegisterState>(
      () => RegisterController(),
    );

class RegisterController extends AutoDisposeNotifier<RegisterState> {
  @override
  RegisterState build() => RegisterState();

  Future<bool> register() async {
    state = state.copyWith(isLoading: true, error: null);

    final req = RegisterRequest(
      email: state.registerData['email'] ?? '',
      username: state.registerData['username'] ?? '',
      password: state.registerData['password'] ?? '',
    );

    try {
      await ref.read(registerServiceProvider).register(req);
      state = state.copyWith(isLoading: false);
      return true;
    } on DioException catch (e) {
      String errorMsg = 'Unknown error';
      String? errorDetail;

      if (e.response != null && e.response?.data != null) {
        var data = e.response?.data;

        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {}
        }

        if (data is Map<String, dynamic>) {
          errorDetail = data['detail'] as String?;
          errorMsg = errorDetail ?? data['title'] ?? errorMsg;
        } else if (data is String) {
          errorMsg = data;
        }
      } else {
        errorMsg = e.message ?? errorMsg;
      }

      state = state.copyWith(error: errorDetail ?? errorMsg, isLoading: false);

      return false;
    }
  }

  /// Cập nhật cả 3 trường
  void updateRegisterData(
    final String email,
    final String username,
    final String password,
  ) {
    state = state.copyWith(
      registerData: {
        'email': email,
        'username': username,
        'password': password,
      },
    );
  }

  /// Cập nhật từng trường riêng lẻ
  void updateRegisterField({
    final String? email,
    final String? username,
    final String? password,
  }) {
    state = state.copyWith(
      registerData: {
        'email': email ?? state.registerData['email'] ?? '',
        'username': username ?? state.registerData['username'] ?? '',
        'password': password ?? state.registerData['password'] ?? '',
      },
    );
  }
}
