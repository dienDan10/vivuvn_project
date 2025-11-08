import '../data/model/notification.dart';

abstract interface class INotificationService {
  /// Register device token
  Future<void> registerDevice();

  /// Deactivate device token
  Future<void> deactivateDevice();

  /// Get notifications
  Future<List<Notification>> getNotifications({final bool unreadOnly = false});

  /// Get unread count
  Future<int> getUnreadCount();

  /// Mark as read
  Future<void> markAsRead(final int notificationId);

  /// Mark all as read
  Future<void> markAllAsRead();

  /// Delete notification
  Future<void> deleteNotification(final int notificationId);

  /// Refresh notifications
  Future<void> refresh();
}
