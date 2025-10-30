import 'package:flutter/material.dart';

import 'hotel_cost_field.dart';
import 'hotel_date_range_picker.dart';
import 'hotel_delete_button.dart';
import 'hotel_note_field.dart';

class HotelCardExpanded extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            HotelCostField(
              hotelId: hotelId,
              initialCost: cost,
            ),
            const SizedBox(height: 12),
            HotelNoteField(
              hotelId: hotelId,
              initialNote: note,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                HotelDeleteButton(
                  hotelId: hotelId,
                  hotelName: hotelName,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
