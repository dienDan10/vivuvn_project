import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../detail/controller/itinerary_detail_controller.dart';
import 'hotel_cost_field.dart';
import 'hotel_date_range_picker.dart';
import 'hotel_delete_button.dart';
import 'hotel_note_field.dart';

class HotelCardExpanded extends ConsumerWidget {
  const HotelCardExpanded({
    required this.hotelId,
    required this.hotelName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.cost,
    required this.note,
    super.key,
  });

  final String hotelId;
  final String hotelName;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final double? cost;
  final String? note;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.itinerary?.isOwner ?? false,
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HotelDateRangePicker(
              hotelId: hotelId,
              checkInDate: checkInDate,
              checkOutDate: checkOutDate,
              isOwner: isOwner,
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            HotelCostField(
              hotelId: hotelId,
              initialCost: cost,
              isOwner: isOwner,
            ),
            const SizedBox(height: 12),
            HotelNoteField(
              hotelId: hotelId,
              initialNote: note,
              isOwner: isOwner,
            ),
            const SizedBox(height: 12),
            if (isOwner)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HotelDeleteButton(hotelId: hotelId, hotelName: hotelName),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
