import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../controller/hotels_controller.dart';

class HotelCheckinDatePicker extends ConsumerWidget {
  const HotelCheckinDatePicker({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final hotelsState = ref.watch(hotelsControllerProvider);
    final controller = ref.read(hotelsControllerProvider.notifier);

    final displayedDate = hotelsState.formCheckInDate ?? DateTime.now();
    final isDefault = hotelsState.formCheckInDate == null;

    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: hotelsState.formCheckInDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (picked != null) {
          controller.setFormCheckInDate(picked);
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
              'Check-in',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy').format(displayedDate),
              style: TextStyle(
                fontSize: 14,
                color: isDefault ? Colors.grey[400] : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
