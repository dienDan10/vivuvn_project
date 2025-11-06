import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/itinerary/view-itinerary-list/models/user.dart';
import '../data/api/user_api.dart';
import 'i_user_service.dart';

final userServiceProvider = Provider.autoDispose<UserService>((final ref) {
  final userApi = ref.read(userApiProvider);
  return UserService(userApi);
});

class UserService implements IUserService {
  final UserApi _userApi;
  UserService(this._userApi);
  @override
  Future<User> fetchUserProfile() {
    return _userApi.fetchUserProfile();
  }
}
