// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic> loginData;
  final bool sendingForgotPassword;
  final String? forgotPasswordError;
  final bool sendForgotPasswordSuccess;
  final bool sendingResetPassword;
  final String? resetPasswordError;

  LoginState({
    this.isLoading = false,
    this.error,
    this.loginData = const {},
    this.sendingForgotPassword = false,
    this.forgotPasswordError,
    this.sendForgotPasswordSuccess = false,
    this.sendingResetPassword = false,
    this.resetPasswordError,
  });

  LoginState copyWith({
    final bool? isLoading,
    final String? error,
    final Map<String, dynamic>? loginData,
    final bool? sendingForgotPassword,
    final String? forgotPasswordError,
    final bool? sendForgotPasswordSuccess,
    final bool? sendingResetPassword,
    final String? resetPasswordError,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      loginData: loginData ?? this.loginData,
      sendingForgotPassword:
          sendingForgotPassword ?? this.sendingForgotPassword,
      forgotPasswordError: forgotPasswordError ?? this.forgotPasswordError,
      sendForgotPasswordSuccess:
          sendForgotPasswordSuccess ?? this.sendForgotPasswordSuccess,
      sendingResetPassword: sendingResetPassword ?? this.sendingResetPassword,
      resetPasswordError: resetPasswordError ?? this.resetPasswordError,
    );
  }
}
