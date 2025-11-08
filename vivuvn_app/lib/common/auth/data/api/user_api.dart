import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/network/network_service.dart';
import '../../../../features/itinerary/view-itinerary-list/models/user.dart';

final userApiProvider = Provider.autoDispose<UserApi>((final ref) {
  final dio = ref.read(networkServiceProvider);
  return UserApi(dio);
});

class UserApi {
  final Dio dio;

  UserApi(this.dio);

  Future<User> fetchUserProfile() async {
    final response = await dio.get('/api/v1/users/me');
    return User.fromMap(response.data as Map<String, dynamic>);
  }
}
