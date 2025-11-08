import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/toast/global_toast.dart';
import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../data/dto/register_request.dart';
import '../data/dto/verify_email_request.dart';
import '../service/register_service.dart';
import '../state/register_state.dart';

final registerControllerProvider =
    AutoDisposeNotifierProvider<RegisterController, RegisterState>(
      () => RegisterController(),
    );

class RegisterController extends AutoDisposeNotifier<RegisterState> {
  @override
  RegisterState build() => RegisterState();

  Future<void> register(
    final String email,
    final String username,
    final String password,
  ) async {
    state = state.copyWith(
      registering: true,
      registerError: null,
      registerSuccess: false,
      verifingEmailSuccess: false,
    );

    final req = RegisterRequest(
      email: email,
      username: username,
      password: password,
    );

    try {
      await ref.read(registerServiceProvider).register(req);
      state = state.copyWith(registerSuccess: true);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(registerError: errorMsg);
    } catch (e) {
      state = state.copyWith(
        registerError: 'Đã có lỗi xảy ra trong quá trình đăng ký',
      );
    } finally {
      state = state.copyWith(registering: false);
    }
  }

  Future<void> verifyEmail(
    final String verificationCode,
    final String email,
  ) async {
    state = state.copyWith(verifingEmail: true, verifyEmailError: null);

    try {
      final verificationRequest = VerifyEmailRequest(
        email: email,
        token: verificationCode,
      );
      await ref.read(registerServiceProvider).verifyEmail(verificationRequest);
      state = state.copyWith(verifingEmailSuccess: true);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(verifyEmailError: errorMsg);
    } catch (e) {
      state = state.copyWith(
        verifyEmailError:
            'Đã có lỗi xảy ra trong quá trình xác thực email',
      );
    } finally {
      state = state.copyWith(verifingEmail: false);
    }
  }

  Future<void> resendVerificationEmail(
    final String email,
    final BuildContext context,
  ) async {
    try {
      await ref.read(registerServiceProvider).resendVerificationEmail(email);

      if (context.mounted) {
        GlobalToast.showSuccessToast(
          context,
          message: 'Đã gửi lại email xác thực thành công',
        );
      }
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(verifyEmailError: errorMsg);
    } catch (e) {
      state = state.copyWith(
        verifyEmailError:
            'Đã có lỗi xảy ra trong quá trình gửi lại email xác thực',
      );
    }
  }
}
