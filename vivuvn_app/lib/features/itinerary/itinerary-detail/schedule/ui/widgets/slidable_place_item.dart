import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../controller/itinerary_schedule_controller.dart';
import '../../model/itinerary_item.dart';
import 'schedule_place_card.dart';

class SlidablePlaceItem extends ConsumerWidget {
  final ItineraryItem item;
  final int dayId;
  final int index;

  const SlidablePlaceItem({
    super.key,
    required this.item,
    required this.dayId,
    required this.index,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Slidable(
      key: ValueKey('${dayId}_${item.itineraryItemId}'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.18,
        children: [
          SlidableAction(
            onPressed: (_) async {
              await ref
                  .read(itineraryScheduleControllerProvider.notifier)
                  .deleteItem(dayId, item.itineraryItemId);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa ${item.location.name}')),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Xóa',
          ),
        ],
      ),
      child: SchedulePlaceCard(
        dayId: dayId,
        index: index,
        location: item.location,
      ),
    );
  }
}
