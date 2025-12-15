import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/notification_controller.dart';
import '../data/enum/notification_sort.dart';

class SortButton extends ConsumerWidget {
  const SortButton({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final currentSort = ref.watch(
      notificationControllerProvider.select((final state) => state.currentSort),
    );

    final theme = Theme.of(context);
    return IconButton(
      icon: const Icon(Icons.sort, size: 24),
      tooltip: 'Sort by',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          barrierColor:
              theme.colorScheme.scrim.withValues(alpha: 0.4),
          builder: (final context) {
            final sheetTheme = Theme.of(context);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Sắp xếp theo',
                      style: sheetTheme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: sheetTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.arrow_downward,
                      color: currentSort == NotificationSort.newest
                          ? sheetTheme.colorScheme.primary
                          : sheetTheme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      'Mới nhất',
                      style: sheetTheme.textTheme.bodyMedium?.copyWith(
                        color: sheetTheme.colorScheme.onSurface,
                      ),
                    ),
                    selected: currentSort == NotificationSort.newest,
                    onTap: () {
                      ref
                          .read(notificationControllerProvider.notifier)
                          .setSort(NotificationSort.newest);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.arrow_upward,
                      color: currentSort == NotificationSort.oldest
                          ? sheetTheme.colorScheme.primary
                          : sheetTheme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      'Cũ nhất',
                      style: sheetTheme.textTheme.bodyMedium?.copyWith(
                        color: sheetTheme.colorScheme.onSurface,
                      ),
                    ),
                    selected: currentSort == NotificationSort.oldest,
                    onTap: () {
                      ref
                          .read(notificationControllerProvider.notifier)
                          .setSort(NotificationSort.oldest);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
