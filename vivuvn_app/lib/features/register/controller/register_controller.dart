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
    try {
      state = state.copyWith(isLoading: true, error: null, emailError: null);

      final req = RegisterRequest(
        email: state.registerData['email'] ?? '',
        username: state.registerData['username'] ?? '',
        password: state.registerData['password'] ?? '',
      );

      await ref.read(registerServiceProvider).register(req);

      return true;
    } on DioException catch (e) {
      String errorMsg = 'Unknown error';

      if (e.response != null && e.response?.data != null) {
        var data = e.response?.data;

        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {}
        }

        if (data is Map<String, dynamic>) {
          errorMsg = data['detail'] ?? data['title'] ?? errorMsg;
        } else if (data is String) {
          errorMsg = data;
        }
      } else {
        errorMsg = e.message ?? errorMsg;
      }

      // nếu là lỗi email trùng thì bind vào emailError
      if (errorMsg.contains('Email is already in use')) {
        state = state.copyWith(emailError: errorMsg, error: null);
      } else {
        state = state.copyWith(error: errorMsg, emailError: null);
      }

      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

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

  void clearEmailError() {
    state = state.copyWith(emailError: null);
  }
}
