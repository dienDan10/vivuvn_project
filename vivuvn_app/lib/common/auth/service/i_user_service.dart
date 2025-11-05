import '../../../features/itinerary/view-itinerary-list/models/user.dart';

abstract interface class IUserService {
  Future<User> fetchUserProfile();
}
