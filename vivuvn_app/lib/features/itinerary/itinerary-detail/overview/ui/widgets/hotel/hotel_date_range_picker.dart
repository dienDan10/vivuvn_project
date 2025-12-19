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
    this.isOwner = true,
    super.key,
  });

  final String hotelId;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final bool isOwner;

  DateTime _toDateOnly(final DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _pickDateRange(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDayOfWeek: 1,
    );

    final startInitial = (checkInDate != null && checkInDate!.year > 2000)
        ? checkInDate!
        : DateTime.now();
    final endInitial = (checkOutDate != null && checkOutDate!.year > 2000)
        ? checkOutDate!
        : startInitial.add(const Duration(days: 1));

    final result = await showCalendarDatePicker2Dialog(
      context: context,
      value: [startInitial, endInitial],
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
    if (!success) {
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
              Text(
                'NHẬN PHÒNG',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: isOwner ? () => _pickDateRange(context, ref) : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkInDate!.year <= 2000
                              ? 'Chưa đặt ngày'
                              : dateFormatter.format(checkInDate!),
                        ),
                      ),
                      if (isSaving)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
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
              Text(
                'TRẢ PHÒNG',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: isOwner ? () => _pickDateRange(context, ref) : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkOutDate!.year <= 2000
                              ? 'Chưa đặt ngày'
                              : dateFormatter.format(checkOutDate!),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      if (isSaving)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
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
