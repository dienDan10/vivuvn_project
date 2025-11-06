import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/notification_controller.dart';

class NotificationBadge extends ConsumerWidget {
  final Widget child;
  const NotificationBadge({super.key, required this.child});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final unreadCount = ref.watch(
      notificationControllerProvider.select((final state) => state.unreadCount),
    );

    return Badge(
      isLabelVisible: unreadCount > 0,
      label: Text(
        unreadCount > 99 ? '99+' : unreadCount.toString(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red,
      child: child,
    );
  }
}
