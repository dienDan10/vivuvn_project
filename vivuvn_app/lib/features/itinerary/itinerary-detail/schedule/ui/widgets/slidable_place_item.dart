import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../../detail/controller/itinerary_detail_controller.dart';
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
    final success = await ref
        .read(itineraryScheduleControllerProvider.notifier)
        .deleteItem(widget.item.itineraryItemId);

    // Không thông báo nếu xóa thành công; chỉ thông báo khi có lỗi
    if (!success && mounted) {
      final error =
          ref.read(itineraryScheduleControllerProvider).error ??
          'Không thể xóa địa điểm khỏi lịch trình';
      GlobalToast.showErrorToast(context, message: error);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.isOwner ?? false,
      ),
    );

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
            enabled: isOwner,
            endActionPane: isOwner
                ? ActionPane(
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
                  )
                : null,
            child: SchedulePlaceCard(item: widget.item),
          ),
        ],
      ),
    );
  }
}
