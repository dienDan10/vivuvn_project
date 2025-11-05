// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../data/enum/notification_filter.dart';
import '../data/enum/notification_sort.dart';
import '../data/model/notification.dart';

class NotificationState {
  final List<Notification> notifications;
  final int unreadCount;
  final NotificationFilter currentFilter;
  final NotificationSort currentSort;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.currentFilter = NotificationFilter.all,
    this.currentSort = NotificationSort.newest,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  NotificationState copyWith({
    final List<Notification>? notifications,
    final int? unreadCount,
    final NotificationFilter? currentFilter,
    final NotificationSort? currentSort,
    final bool? isLoading,
    final bool? isRefreshing,
    final String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSort: currentSort ?? this.currentSort,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
    );
  }
}
