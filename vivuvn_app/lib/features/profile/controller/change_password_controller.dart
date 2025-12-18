import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/validator/validation_exception.dart';
import '../../../common/validator/validator.dart';
import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../service/profile_service.dart';
import '../state/change_password_state.dart';

final changePasswordControllerProvider =
    AutoDisposeNotifierProvider<ChangePasswordController, ChangePasswordState>(
      () => ChangePasswordController(),
    );

class ChangePasswordController
    extends AutoDisposeNotifier<ChangePasswordState> {
  @override
  ChangePasswordState build() {
    return ChangePasswordState();
  }

  void setCurrentPassword(final String password) {
    state = state.copyWith(
      currentPassword: password,
      currentPasswordError: null,
    );
  }

  void setNewPassword(final String password) {
    state = state.copyWith(newPassword: password, newPasswordError: null);
  }

  void toggleCurrentPasswordVisibility() {
    state = state.copyWith(
      obscureCurrentPassword: !state.obscureCurrentPassword,
    );
  }

  void toggleNewPasswordVisibility() {
    state = state.copyWith(obscureNewPassword: !state.obscureNewPassword);
  }

  void reset() {
    state = ChangePasswordState();
  }

  String? _validateCurrentPassword(final String password) {
    return Validator.notEmpty(password, fieldName: 'Mật khẩu hiện tại');
  }

  String? _validateNewPassword(final String password) {
    // Validate không được để trống
    final emptyError = Validator.notEmpty(password, fieldName: 'Mật khẩu mới');
    if (emptyError != null) {
      return emptyError;
    }

    // Validate độ dài tối thiểu
    if (password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    // Validate từ cấm
    if (Validator.containsSensitiveWords(password)) {
      return 'Mật khẩu chứa từ cấm';
    }

    return null;
  }

  bool _validate() {
    final currentPasswordError = _validateCurrentPassword(
      state.currentPassword,
    );
    final newPasswordError = _validateNewPassword(state.newPassword);

    state = state.copyWith(
      currentPasswordError: currentPasswordError,
      newPasswordError: newPasswordError,
    );

    return currentPasswordError == null && newPasswordError == null;
  }

  Future<String> changePassword() async {
    if (!_validate()) {
      throw ValidationException('Vui lòng kiểm tra lại thông tin');
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final profileService = ref.read(profileServiceProvider);
      final message = await profileService.changePassword(
        currentPassword: state.currentPassword.trim(),
        newPassword: state.newPassword.trim(),
      );

      state = state.copyWith(isLoading: false);
      return message;
    } on DioException catch (e) {
      final errorMessage = DioExceptionHandler.handleException(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      throw Exception(errorMessage);
    } on ValidationException catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}
