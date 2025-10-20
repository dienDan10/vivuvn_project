import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../controller/itinerary_schedule_controller.dart';
import 'schedule_place_card.dart';

class SlidablePlaceItem extends ConsumerWidget {
  final int itineraryId;
  final int dayId;
  final int itemId;
  final int locationId;
  final String locationName;
  final int index;
  final dynamic location;

  const SlidablePlaceItem({
    super.key,
    required this.itineraryId,
    required this.dayId,
    required this.itemId,
    required this.locationId,
    required this.locationName,
    required this.index,
    required this.location,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Slidable(
      key: ValueKey(locationId),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.18,
        children: [
          SlidableAction(
            onPressed: (_) async {
              final scaffoldContext = context;
              await ref
                  .read(itineraryScheduleControllerProvider.notifier)
                  .deleteItem(itineraryId, dayId, itemId);

              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa $locationName'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Xóa',
          ),
        ],
      ),
      child: SchedulePlaceCard(index: index, location: location),
    );
  }
}
