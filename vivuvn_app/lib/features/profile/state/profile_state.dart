import '../../itinerary/view-itinerary-list/models/user.dart';

class ProfileState {
  final bool isLoading;
  final User? user;
  final String? error;
  final bool isEditingUsername;
  final bool isEditingPhone;
  final String? usernameText;
  final String? phoneText;

  ProfileState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isEditingUsername = false,
    this.isEditingPhone = false,
    this.usernameText,
    this.phoneText,
  });

  ProfileState copyWith({
    final bool? isLoading,
    final User? user,
    final String? error,
    final bool? isEditingUsername,
    final bool? isEditingPhone,
    final String? usernameText,
    final String? phoneText,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      isEditingUsername: isEditingUsername ?? this.isEditingUsername,
      isEditingPhone: isEditingPhone ?? this.isEditingPhone,
      usernameText: usernameText ?? this.usernameText,
      phoneText: phoneText ?? this.phoneText,
    );
  }
}

