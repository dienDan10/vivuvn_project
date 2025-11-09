class ChangePasswordState {
  final bool isLoading;
  final String? error;
  final String currentPassword;
  final String newPassword;
  final bool obscureCurrentPassword;
  final bool obscureNewPassword;
  final String? currentPasswordError;
  final String? newPasswordError;

  ChangePasswordState({
    this.isLoading = false,
    this.error,
    this.currentPassword = '',
    this.newPassword = '',
    this.obscureCurrentPassword = true,
    this.obscureNewPassword = true,
    this.currentPasswordError,
    this.newPasswordError,
  });

  ChangePasswordState copyWith({
    final bool? isLoading,
    final String? error,
    final String? currentPassword,
    final String? newPassword,
    final bool? obscureCurrentPassword,
    final bool? obscureNewPassword,
    final String? currentPasswordError,
    final String? newPasswordError,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      obscureCurrentPassword: obscureCurrentPassword ?? this.obscureCurrentPassword,
      obscureNewPassword: obscureNewPassword ?? this.obscureNewPassword,
      currentPasswordError: currentPasswordError,
      newPasswordError: newPasswordError,
    );
  }
}

