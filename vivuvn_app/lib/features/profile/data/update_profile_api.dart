import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/remote/network/network_service.dart';
import 'dto/change_password_response.dart';
import 'dto/update_phone_number_response.dart';
import 'dto/update_username_response.dart';
import 'dto/upload_avatar_response.dart';

final updateProfileApiProvider = Provider.autoDispose<UpdateProfileApi>((final ref) {
  final dio = ref.watch(networkServiceProvider);
  return UpdateProfileApi(dio);
});

final class UpdateProfileApi {
  final Dio _dio;

  UpdateProfileApi(this._dio);

  Future<UploadAvatarResponse> uploadAvatar({
    required final String userId,
    required final String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(imagePath),
    });

    final response = await _dio.put(
      '/api/v1/users/$userId/avatar',
      data: formData,
    );

    return UploadAvatarResponse.fromMap(response.data);
  }

  Future<UpdateUsernameResponse> updateUsername({
    required final String userId,
    required final String username,
  }) async {
    final response = await _dio.put(
      '/api/v1/users/$userId/username',
      data: {'username': username},
    );

    return UpdateUsernameResponse.fromMap(response.data);
  }

  Future<UpdatePhoneNumberResponse> updatePhoneNumber({
    required final String userId,
    required final String phoneNumber,
  }) async {
    final response = await _dio.put(
      '/api/v1/users/$userId/phone-number',
      data: {'phoneNumber': phoneNumber},
    );

    return UpdatePhoneNumberResponse.fromMap(response.data);
  }

  Future<ChangePasswordResponse> changePassword({
    required final String currentPassword,
    required final String newPassword,
  }) async {
    final response = await _dio.post(
      '/api/v1/auth/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    return ChangePasswordResponse.fromMap(response.data);
  }
}

