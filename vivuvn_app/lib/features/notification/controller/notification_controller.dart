import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/remote/exception/dio_exception_handler.dart';
import '../data/enum/notification_filter.dart';
import '../data/enum/notification_sort.dart';
import '../data/model/notification.dart';
import '../service/notification_service.dart';
import '../state/notification_state.dart';

final notificationControllerProvider =
    NotifierProvider<NotificationController, NotificationState>(
      () => NotificationController(),
    );

class NotificationController extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    // Initial state
    return NotificationState();
  }

  /// Load notifications based on current filter
  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(notificationServiceProvider);

      // Load notifications based on filter
      final notifications = await service.getNotifications(
        unreadOnly: state.currentFilter == NotificationFilter.unread,
      );

      // Load unread count
      final unreadCount = await service.getUnreadCount();

      // Sort notifications
      final sortedNotifications = _sortNotifications(notifications);

      state = state.copyWith(
        notifications: sortedNotifications,
        unreadCount: unreadCount,
      );
    } on DioException catch (e) {
      final String errMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errMsg);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Sort notifications based on current sort order
  List<Notification> _sortNotifications(
    final List<Notification> notifications,
  ) {
    final sorted = List<Notification>.from(notifications);

    if (state.currentSort == NotificationSort.newest) {
      sorted.sort((final a, final b) => b.createdAt.compareTo(a.createdAt));
    } else {
      sorted.sort((final a, final b) => a.createdAt.compareTo(b.createdAt));
    }

    return sorted;
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);

    try {
      final service = ref.read(notificationServiceProvider);

      final notifications = await service.getNotifications(
        unreadOnly: state.currentFilter == NotificationFilter.unread,
      );

      final unreadCount = await service.getUnreadCount();

      final sortedNotifications = _sortNotifications(notifications);

      state = state.copyWith(
        notifications: sortedNotifications,
        unreadCount: unreadCount,
      );
    } on DioException catch (e) {
      final String errMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errMsg);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isRefreshing: false);
    }
  }

  /// Change filter (All / Unread)
  void setFilter(final NotificationFilter filter) {
    if (state.currentFilter == filter) return;

    state = state.copyWith(currentFilter: filter);
    loadNotifications();
  }

  /// Change sort order (Newest / Oldest)
  void setSort(final NotificationSort sort) {
    if (state.currentSort == sort) return;

    state = state.copyWith(currentSort: sort);

    // Re-sort current notifications
    final sorted = _sortNotifications(state.notifications);
    state = state.copyWith(notifications: sorted);
  }

  /// Mark single notification as read
  Future<void> markAsRead(final int notificationId) async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.markAsRead(notificationId);

      // Update local state
      final updated = state.notifications.map((final n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;

      state = state.copyWith(
        notifications: updated,
        unreadCount: newUnreadCount,
      );
    } on DioException catch (e) {
      final String errMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errMsg);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.markAllAsRead();

      // Update local state
      final updated = state.notifications.map((final n) {
        return n.copyWith(isRead: true);
      }).toList();

      state = state.copyWith(notifications: updated, unreadCount: 0);
    } on DioException catch (e) {
      final String errMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errMsg);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Delete notification
  Future<void> deleteNotification(final int notificationId) async {
    try {
      final service = ref.read(notificationServiceProvider);

      // Update local state
      final notification = state.notifications.firstWhere(
        (final n) => n.id == notificationId,
      );
      final updated = state.notifications
          .where((final n) => n.id != notificationId)
          .toList();

      final newUnreadCount = !notification.isRead && state.unreadCount > 0
          ? state.unreadCount - 1
          : state.unreadCount;

      state = state.copyWith(
        notifications: updated,
        unreadCount: newUnreadCount,
      );

      await service.deleteNotification(notificationId);
    } on DioException catch (e) {
      final String errMsg = DioExceptionHandler.handleException(e);
      state = state.copyWith(error: errMsg);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
