import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../controller/hotels_controller.dart';

class HotelCheckinPicker extends ConsumerWidget {
  const HotelCheckinPicker({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final hotelsState = ref.watch(hotelsControllerProvider);
    final controller = ref.read(hotelsControllerProvider.notifier);

    return InkWell(
      onTap: () async {
        final config = CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range,
          firstDayOfWeek: 1,
        );
        final result = await showCalendarDatePicker2Dialog(
          context: context,
          value: [hotelsState.formCheckInDate, hotelsState.formCheckOutDate],
          config: config,
          dialogSize: const Size(340, 400),
          borderRadius: BorderRadius.circular(12),
        );
        if (result == null || result.isEmpty) return;

        DateTime? start = result[0];
        DateTime? end = (result.length > 1) ? result[1] : null;
        if (start == null || end == null) return;
        // Normalize order
        if (end.isBefore(start)) {
          final tmp = start;
          start = end;
          end = tmp;
        }
        controller.setFormCheckInDate(DateTime(start.year, start.month, start.day));
        controller.setFormCheckOutDate(DateTime(end.year, end.month, end.day));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check-in',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              hotelsState.formCheckInDate != null
                  ? DateFormat('dd/MM/yyyy').format(hotelsState.formCheckInDate!)
                  : 'Chọn ngày',
              style: TextStyle(
                fontSize: 14,
                color: hotelsState.formCheckInDate != null
                    ? Colors.black
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
