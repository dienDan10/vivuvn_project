import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/notification_controller.dart';
import '../data/enum/notification_filter.dart';
import 'filter_tab.dart';

class NotificationFilterTabs extends ConsumerWidget {
  const NotificationFilterTabs({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final currentFilter = ref.watch(
      notificationControllerProvider.select((final s) => s.currentFilter),
    );

    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: FilterTab(
              label: 'Tất cả',
              isSelected: currentFilter == NotificationFilter.all,
              onTap: () => {
                ref
                    .read(notificationControllerProvider.notifier)
                    .setFilter(NotificationFilter.all),
              },
            ),
          ),
          Expanded(
            child: FilterTab(
              label: 'Chưa đọc',
              isSelected: currentFilter == NotificationFilter.unread,
              onTap: () => {
                ref
                    .read(notificationControllerProvider.notifier)
                    .setFilter(NotificationFilter.unread),
              },
            ),
          ),
        ],
      ),
    );
  }
}
