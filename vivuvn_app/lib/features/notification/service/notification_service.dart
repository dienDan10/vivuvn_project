import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/fcm_service.dart';
import '../data/api/notification_api.dart';
import '../data/dto/register_device_request.dart';
import '../data/model/notification.dart';
import 'i_notification_service.dart';

final notificationServiceProvider = Provider<INotificationService>((final ref) {
  final api = ref.watch(notificationApiProvider);
  final fcmService = ref.watch(fcmServiceProvider);
  return NotificationService(api, fcmService);
});

class NotificationService implements INotificationService {
  final NotificationApi _api;
  final FcmService _fcmService;

  NotificationService(this._api, this._fcmService);

  @override
  Future<void> registerDevice() async {
    // Get FCM token
    final token = await _fcmService.getToken();
    if (token == null) {
      return;
    }

    // Get device info
    final deviceType = _fcmService.getDeviceType();
    final deviceName = await _fcmService.getDeviceName();

    // Register with backend
    final request = RegisterDeviceRequest(
      fcmToken: token,
      deviceType: deviceType,
      deviceName: deviceName,
    );

    await _api.registerDevice(request);
  }

  @override
  Future<void> deactivateDevice() async {
    final token = await _fcmService.getToken();
    if (token != null) {
      await _api.deactivateDevice(token);
    }
  }

  @override
  Future<List<Notification>> getNotifications({
    final bool unreadOnly = false,
  }) async {
    return await _api.getNotifications(unreadOnly: unreadOnly);
  }

  @override
  Future<void> deleteNotification(final int notificationId) async {
    await _api.deleteNotification(notificationId);
  }

  @override
  Future<int> getUnreadCount() async {
    return await _api.getUnreadCount();
  }

  @override
  Future<void> markAllAsRead() async {
    await _api.markAllAsRead();
  }

  @override
  Future<void> markAsRead(final int notificationId) async {
    await _api.markAsRead(notificationId);
  }

  @override
  Future<void> refresh() {
    // TODO: implement refresh
    throw UnimplementedError();
  }
}
