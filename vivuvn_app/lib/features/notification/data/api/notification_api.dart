import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/remote/network/network_service.dart';
import '../dto/register_device_request.dart';
import '../model/notification.dart';

class NotificationApi {
  final Dio _dio;
  NotificationApi(this._dio);

  // Register device token
  Future<void> registerDevice(final RegisterDeviceRequest request) async {
    await _dio.post('/api/v1/users/devices', data: request.toJson());
  }

  // Deactivate device token
  Future<void> deactivateDevice(final String fcmToken) async {
    await _dio.delete('/api/v1/users/devices/$fcmToken');
  }

  // Get user notifications
  Future<List<Notification>> getNotifications({
    final bool unreadOnly = false,
  }) async {
    final response = await _dio.get(
      '/api/v1/notifications',
      queryParameters: {'unreadOnly': unreadOnly},
    );
    final data = response.data as List<dynamic>;
    return data
        .map((final e) => Notification.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    final response = await _dio.get('/api/v1/notifications/unread/count');
    return response.data['unreadCount'] as int;
  }

  // Mark notification as read
  Future<void> markAsRead(final int notificationId) async {
    await _dio.put('/api/v1/notifications/$notificationId/read');
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    await _dio.put('/api/v1/notifications/mark-all-read');
  }

  // Delete notification
  Future<void> deleteNotification(final int notificationId) async {
    await _dio.delete('/api/v1/notifications/$notificationId');
  }
}

final notificationApiProvider = Provider.autoDispose<NotificationApi>((
  final ref,
) {
  final dio = ref.watch(networkServiceProvider);
  return NotificationApi(dio);
});
