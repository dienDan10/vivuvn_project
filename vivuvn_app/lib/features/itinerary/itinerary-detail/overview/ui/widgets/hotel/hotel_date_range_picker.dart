import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../../common/toast/global_toast.dart';
import '../../../controller/hotels_controller.dart';
import '../../../state/hotels_state.dart';

class HotelDateRangePicker extends ConsumerWidget {
  const HotelDateRangePicker({
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    super.key,
  });

  final String hotelId;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  DateTime _toDateOnly(final DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _pickDateRange(final BuildContext context, final WidgetRef ref) async {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDayOfWeek: 1,
    );

    final result = await showCalendarDatePicker2Dialog(
      context: context,
      value: [checkInDate, checkOutDate],
      config: config,
      dialogSize: const Size(340, 400),
      borderRadius: BorderRadius.circular(12),
    );

    if (result == null || result.isEmpty) return;

    DateTime? newStart = result[0];
    DateTime? newEnd = (result.length > 1) ? result[1] : null;
    if (newStart != null) newStart = _toDateOnly(newStart);
    if (newEnd != null) newEnd = _toDateOnly(newEnd);
    if (newStart == null || newEnd == null) return;
    if (newEnd.isBefore(newStart)) {
      final tmp = newStart;
      newStart = newEnd;
      newEnd = tmp;
    }

    final success = await ref
        .read(hotelsControllerProvider.notifier)
        .updateHotelDate(
          id: hotelId,
          checkInDate: newStart,
          checkOutDate: newEnd,
        );

    if (!context.mounted) return;
    if (success) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Cập nhật ngày thành công',
      );
    } else {
      GlobalToast.showErrorToast(context, message: 'Cập nhật ngày thất bại');
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final isSaving = ref.watch(
      hotelsControllerProvider.select(
        (final state) => state.isSaving(hotelId, HotelSavingType.dates),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NHẬN PHÒNG',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _pickDateRange(context, ref),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkInDate != null
                              ? dateFormatter.format(checkInDate!)
                              : '--/--',
                        ),
                      ),
                      if (isSaving)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TRẢ PHÒNG',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _pickDateRange(context, ref),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkOutDate != null
                              ? dateFormatter.format(checkOutDate!)
                              : '--/--',
                          textAlign: TextAlign.right,
                        ),
                      ),
                      if (isSaving)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
