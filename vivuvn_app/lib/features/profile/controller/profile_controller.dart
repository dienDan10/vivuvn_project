import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/auth/controller/auth_controller.dart';
import '../../../common/validator/validation_exception.dart';
import '../../../common/validator/validator.dart';
import '../../itinerary/view-itinerary-list/models/user.dart';
import '../service/profile_service.dart';
import '../state/profile_state.dart';

final profileControllerProvider =
    AutoDisposeNotifierProvider<ProfileController, ProfileState>(
  () => ProfileController(),
);

class ProfileController extends AutoDisposeNotifier<ProfileState> {
  @override
  ProfileState build() {
    // Lấy user từ AuthState khi khởi tạo
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    if (user != null) {
      return ProfileState(user: user);
    }

    return ProfileState();
  }

  void loadUserFromAuth() {
    final authState = ref.read(authControllerProvider);
    final user = authState.user;

    if (user != null) {
      state = state.copyWith(user: user);
    }
  }

  void updateUser(final User user) {
    state = state.copyWith(user: user);
  }

  Future<String> uploadAvatar(final String imagePath) async {
    final currentUser = state.user;
    if (currentUser == null) {
      throw Exception('Người dùng không tồn tại');
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final profileService = ref.read(profileServiceProvider);
      final avatarUrl = await profileService.uploadAvatar(
        userId: currentUser.id,
        imagePath: imagePath,
      );

      // Cập nhật user với avatar URL mới
      final updatedUser = currentUser.copyWith(userPhoto: avatarUrl);
      state = state.copyWith(user: updatedUser, isLoading: false);

      // Cập nhật AuthState để đồng bộ
      ref.read(authControllerProvider.notifier).setAuthenticated(updatedUser);

      return 'Đã thay đổi avatar thành công.';
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  void setEditingUsername(final bool isEditing, {final String? text}) {
    state = state.copyWith(
      isEditingUsername: isEditing,
      usernameText: text,
    );
  }

  void setEditingPhone(final bool isEditing, {final String? text}) {
    state = state.copyWith(
      isEditingPhone: isEditing,
      phoneText: text,
    );
  }

  void startEditingUsername() {
    final currentUser = state.user;
    state = state.copyWith(
      isEditingUsername: true,
      usernameText: currentUser?.username,
    );
  }

  void startEditingPhone() {
    final currentUser = state.user;
    state = state.copyWith(
      isEditingPhone: true,
      phoneText: currentUser?.phoneNumber,
    );
  }

  void cancelEditingUsername() {
    final currentUser = state.user;
    state = state.copyWith(
      isEditingUsername: false,
      usernameText: currentUser?.username,
    );
  }

  void cancelEditingPhone() {
    final currentUser = state.user;
    state = state.copyWith(
      isEditingPhone: false,
      phoneText: currentUser?.phoneNumber,
    );
  }

  Future<String> updateUsername(final String username) async {
    final currentUser = state.user;
    if (currentUser == null) {
      throw Exception('Người dùng không tồn tại');
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      // Validate empty
      final emptyError = Validator.notEmpty(username, fieldName: 'Tên người dùng');
      if (emptyError != null) {
        throw ValidationException(emptyError);
      }

      // Validate từ cấm
      if (Validator.containsSensitiveWords(username)) {
        throw ValidationException('Tên người dùng chứa từ cấm');
      }

      final profileService = ref.read(profileServiceProvider);
      final newName = await profileService.updateUsername(
        userId: currentUser.id,
        username: username.trim(),
      );

      // Cập nhật user với username mới
      final updatedUser = currentUser.copyWith(username: newName);
      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        isEditingUsername: false,
        usernameText: newName,
      );

      // Cập nhật AuthState để đồng bộ
      ref.read(authControllerProvider.notifier).setAuthenticated(updatedUser);

      return 'Đã thay đổi tên người dùng thành công.';
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<String> updatePhoneNumber(final String phoneNumber) async {
    final currentUser = state.user;
    if (currentUser == null) {
      throw Exception('Người dùng không tồn tại');
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      // Validate empty (phone number có thể để trống, nhưng nếu có thì validate)
      if (phoneNumber.trim().isNotEmpty) {
        // Validate từ cấm nếu có nhập
        if (Validator.containsSensitiveWords(phoneNumber)) {
          throw ValidationException('Số điện thoại chứa từ cấm');
        }
      }

      final profileService = ref.read(profileServiceProvider);
      final newPhoneNumber = await profileService.updatePhoneNumber(
        userId: currentUser.id,
        phoneNumber: phoneNumber.trim(),
      );

      // Cập nhật user với phone number mới
      final updatedUser = currentUser.copyWith(phoneNumber: newPhoneNumber);
      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        isEditingPhone: false,
        phoneText: newPhoneNumber,
      );

      // Cập nhật AuthState để đồng bộ
      ref.read(authControllerProvider.notifier).setAuthenticated(updatedUser);

      return 'Đã thay đổi số điện thoại thành công.';
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
}

