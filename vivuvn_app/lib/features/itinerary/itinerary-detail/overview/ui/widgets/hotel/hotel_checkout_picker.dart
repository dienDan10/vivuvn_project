import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../controller/hotels_controller.dart';

class HotelCheckoutPicker extends ConsumerWidget {
  const HotelCheckoutPicker({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final formState = ref.watch(hotelsControllerProvider);
    final controller = ref.read(hotelsControllerProvider.notifier);

    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate:
              formState.formCheckOutDate ??
              (formState.formCheckInDate?.add(const Duration(days: 1)) ??
                  DateTime.now()),
          firstDate: formState.formCheckInDate ?? DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          controller.setFormCheckOutDate(picked);
        }
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
              'Check-out',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              formState.formCheckOutDate != null
                  ? DateFormat('dd/MM/yyyy').format(formState.formCheckOutDate!)
                  : 'Chọn ngày',
              style: TextStyle(
                fontSize: 14,
                color: formState.formCheckOutDate != null
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
