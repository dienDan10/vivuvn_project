import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/notification_controller.dart';
import '../data/enum/notification_filter.dart';
import 'notification_item.dart';

class NotificationList extends ConsumerStatefulWidget {
  const NotificationList({super.key});

  @override
  ConsumerState<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends ConsumerState<NotificationList> {
  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(notificationControllerProvider);

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
              'Lỗi: ${state.error}',
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
              child: const Text('Thử lại'),
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
                  ? 'Không có thông báo chưa đọc'
                  : 'Chưa có thông báo nào',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

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
          return NotificationItem(notification: notification);
        },
      ),
    );
  }
}
