// ignore_for_file: public_member_api_docs, sort_constructors_first
class RegisterState {
  final bool registering;
  final bool registerSuccess;
  final bool verifingEmail;
  final bool verifingEmailSuccess;
  final String? registerError;
  final String? verifyEmailError;
  RegisterState({
    this.registering = false,
    this.registerSuccess = false,
    this.verifingEmail = false,
    this.verifingEmailSuccess = false,
    this.registerError,
    this.verifyEmailError,
  });

  RegisterState copyWith({
    final bool? registering,
    final bool? registerSuccess,
    final bool? verifingEmail,
    final bool? verifingEmailSuccess,
    final String? registerError,
    final String? verifyEmailError,
  }) {
    return RegisterState(
      registering: registering ?? this.registering,
      registerSuccess: registerSuccess ?? this.registerSuccess,
      verifingEmail: verifingEmail ?? this.verifingEmail,
      verifingEmailSuccess: verifingEmailSuccess ?? this.verifingEmailSuccess,
      registerError: registerError ?? this.registerError,
      verifyEmailError: verifyEmailError ?? this.verifyEmailError,
    );
  }
}
