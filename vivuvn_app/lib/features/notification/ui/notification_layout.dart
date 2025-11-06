import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/notification_controller.dart';
import 'notification_filter_tabs.dart';
import 'notification_list.dart';
import 'sort_btn.dart';

class NotificationLayout extends ConsumerStatefulWidget {
  const NotificationLayout({super.key});

  @override
  ConsumerState<NotificationLayout> createState() => _NotificationLayoutState();
}

class _NotificationLayoutState extends ConsumerState<NotificationLayout> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationControllerProvider.notifier).loadNotifications();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final unreadCount = ref.watch(
      notificationControllerProvider.select((final s) => s.unreadCount),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  const Text(
                    'Thông báo',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  // Sort button
                  const SortButton(),
                  if (unreadCount > 0)
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
            ),
            const NotificationFilterTabs(),
            // notification list
            const Expanded(child: NotificationList()),
          ],
        ),
      ),
    );
  }
}
