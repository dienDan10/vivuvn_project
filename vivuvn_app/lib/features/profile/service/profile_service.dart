import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/update_profile_api.dart';

final profileServiceProvider = Provider.autoDispose<ProfileService>((final ref) {
  final api = ref.watch(updateProfileApiProvider);
  return ProfileService(api);
});

final class ProfileService {
  final UpdateProfileApi _api;

  ProfileService(this._api);

  Future<String> uploadAvatar({
    required final String userId,
    required final String imagePath,
  }) async {
    final response = await _api.uploadAvatar(
      userId: userId,
      imagePath: imagePath,
    );
    return response.url;
  }

  Future<String> updateUsername({
    required final String userId,
    required final String username,
  }) async {
    final response = await _api.updateUsername(
      userId: userId,
      username: username,
    );
    return response.newName;
  }

  Future<String> updatePhoneNumber({
    required final String userId,
    required final String phoneNumber,
  }) async {
    final response = await _api.updatePhoneNumber(
      userId: userId,
      phoneNumber: phoneNumber,
    );
    return response.newPhoneNumber;
  }

  Future<String> changePassword({
    required final String currentPassword,
    required final String newPassword,
  }) async {
    final response = await _api.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return response.message;
  }
}

