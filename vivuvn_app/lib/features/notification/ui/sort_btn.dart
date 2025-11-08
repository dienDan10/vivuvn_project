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
          builder: (final context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Sắp xếp theo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.arrow_downward,
                    color: currentSort == NotificationSort.newest
                        ? Theme.of(context).primaryColor
                        : null,
                  ),
                  title: const Text('Mới nhất'),
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
                        ? Theme.of(context).primaryColor
                        : null,
                  ),
                  title: const Text('Cũ nhất'),
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
          ),
        );
      },
    );
  }
}
