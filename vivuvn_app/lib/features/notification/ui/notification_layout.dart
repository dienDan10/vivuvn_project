import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/notification_controller.dart';
import '../data/enum/notification_filter.dart';
import '../data/enum/notification_sort.dart';
import '../state/notification_state.dart';
import 'notification_filter_tabs.dart';
import 'notification_item.dart';

class NotificationLayout extends ConsumerStatefulWidget {
  const NotificationLayout({super.key});

  @override
  ConsumerState<NotificationLayout> createState() => _NotificationLayoutState();
}

class _NotificationLayoutState extends ConsumerState<NotificationLayout> {
  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(notificationControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          // Sort button
          _buildSortButton(context, ref, state),

          // Mark all as read button
          if (state.unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: () {
                ref
                    .read(notificationControllerProvider.notifier)
                    .markAllAsRead();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          NotificationFilterTabs(
            currentFilter: state.currentFilter,
            onFilterChanged: (final filter) {
              ref
                  .read(notificationControllerProvider.notifier)
                  .setFilter(filter);
            },
          ),

          // Notifications list
          Expanded(child: _buildContent(context, ref, state)),
        ],
      ),
    );
  }

  Widget _buildSortButton(
    final BuildContext context,
    final WidgetRef ref,
    final NotificationState state,
  ) {
    return PopupMenuButton<NotificationSort>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort by',
      onSelected: (final sort) {
        ref.read(notificationControllerProvider.notifier).setSort(sort);
      },
      itemBuilder: (final context) => [
        PopupMenuItem(
          value: NotificationSort.newest,
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                color: state.currentSort == NotificationSort.newest
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              const SizedBox(width: 8),
              const Text('Newest First'),
            ],
          ),
        ),
        PopupMenuItem(
          value: NotificationSort.oldest,
          child: Row(
            children: [
              Icon(
                Icons.arrow_upward,
                color: state.currentSort == NotificationSort.oldest
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              const SizedBox(width: 8),
              const Text('Oldest First'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    final BuildContext context,
    final WidgetRef ref,
    final NotificationState state,
  ) {
    // Loading
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(notificationControllerProvider.notifier)
                    .loadNotifications();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty
    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              state.currentFilter == NotificationFilter.unread
                  ? 'No unread notifications'
                  : 'No notifications yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Notifications list with pull to refresh
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(notificationControllerProvider.notifier).refresh();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.notifications.length,
        separatorBuilder: (final context, final index) =>
            const SizedBox(height: 8),
        itemBuilder: (final context, final index) {
          final notification = state.notifications[index];
          return NotificationItem(
            notification: notification,
            onTap: () => _handleNotificationTap(context, ref, notification),
            onMarkAsRead: () {
              ref
                  .read(notificationControllerProvider.notifier)
                  .markAsRead(notification.id);
            },
            onDelete: () {
              ref
                  .read(notificationControllerProvider.notifier)
                  .deleteNotification(notification.id);
            },
          );
        },
      ),
    );
  }

  void _handleNotificationTap(
    final BuildContext context,
    final WidgetRef ref,
    final notification,
  ) {
    // Mark as read if unread
    if (!notification.isRead) {
      ref
          .read(notificationControllerProvider.notifier)
          .markAsRead(notification.id);
    }

    // Navigate to itinerary detail if itineraryId exists
    if (notification.itineraryId != null) {
      Navigator.pushNamed(context, '/itinerary/${notification.itineraryId}');
    }
  }
}
