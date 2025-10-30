import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../controller/itinerary_schedule_controller.dart';
import '../../model/itinerary_item.dart';
import 'schedule_place_card.dart';
import 'transport_section.dart';

class SlidablePlaceItem extends ConsumerStatefulWidget {
  final ItineraryItem item;

  const SlidablePlaceItem({super.key, required this.item});

  @override
  ConsumerState<SlidablePlaceItem> createState() => _SlidablePlaceItemState();
}

class _SlidablePlaceItemState extends ConsumerState<SlidablePlaceItem> {
  void _deleteItineraryItem() async {
    await ref
        .read(itineraryScheduleControllerProvider.notifier)
        .deleteItem(widget.item.itineraryItemId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa ${widget.item.location.name}')),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          if (widget.item.orderIndex > 1)
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
              child: TransportSection(item: widget.item),
            ),
          Slidable(
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.18,
              children: [
                SlidableAction(
                  onPressed: (final _) => _deleteItineraryItem(),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Xóa',
                ),
              ],
            ),
            child: SchedulePlaceCard(item: widget.item),
          ),
        ],
      ),
    );
  }
}
