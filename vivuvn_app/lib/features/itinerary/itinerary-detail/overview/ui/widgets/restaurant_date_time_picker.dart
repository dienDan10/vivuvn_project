import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/restaurants_controller.dart';
import '../../state/restaurants_state.dart';

class RestaurantDateTimePicker extends ConsumerWidget {
  const RestaurantDateTimePicker({
    required this.restaurantId,
    required this.mealDate,
    super.key,
  });

  final String restaurantId;
  final DateTime? mealDate;

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
      firstDayOfWeek: 1,
    );

    final result = await showCalendarDatePicker2Dialog(
      context: context,
      value: [mealDate ?? DateTime.now()],
      config: config,
      dialogSize: const Size(340, 400),
      borderRadius: BorderRadius.circular(12),
    );

    if (result == null || result.isEmpty || result.first == null) return;

    final selectedDate = result.first!;
    final currentTime = mealDate ?? DateTime.now();
    final newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      currentTime.hour,
      currentTime.minute,
    );

    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .updateRestaurantDate(id: restaurantId, date: newDateTime);

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

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final currentTime = TimeOfDay.fromDateTime(mealDate ?? DateTime.now());

    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (picked == null) return;

    final timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .updateRestaurantTime(id: restaurantId, time: timeStr);

    if (!context.mounted) return;
    if (success) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Cập nhật giờ thành công',
      );
    } else {
      GlobalToast.showErrorToast(context, message: 'Cập nhật giờ thất bại');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('HH:mm');
    final isSavingDate = ref.watch(
      restaurantsControllerProvider.select(
        (state) => state.isSaving(restaurantId, RestaurantSavingType.date),
      ),
    );
    final isSavingTime = ref.watch(
      restaurantsControllerProvider.select(
        (state) => state.isSaving(restaurantId, RestaurantSavingType.time),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NGÀY',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _pickDate(context, ref),
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
                          mealDate != null
                              ? dateFormatter.format(mealDate!)
                              : '--/--/----',
                        ),
                      ),
                      if (isSavingDate)
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
                'GIỜ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _pickTime(context, ref),
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
                          mealDate != null
                              ? timeFormatter.format(mealDate!)
                              : '--:--',
                          textAlign: TextAlign.right,
                        ),
                      ),
                      if (isSavingTime)
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
