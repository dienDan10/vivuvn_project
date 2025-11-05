import 'package:flutter/material.dart';

import '../data/enum/notification_filter.dart';
import 'filter_tab.dart';

class NotificationFilterTabs extends StatelessWidget {
  final NotificationFilter currentFilter;
  final ValueChanged<NotificationFilter> onFilterChanged;

  const NotificationFilterTabs({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: FilterTab(
              label: 'All',
              isSelected: currentFilter == NotificationFilter.all,
              onTap: () => onFilterChanged(NotificationFilter.all),
            ),
          ),
          Expanded(
            child: FilterTab(
              label: 'Unread',
              isSelected: currentFilter == NotificationFilter.unread,
              onTap: () => onFilterChanged(NotificationFilter.unread),
            ),
          ),
        ],
      ),
    );
  }
}
