import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_schedule_controller.dart';
import 'add_place_bottom_sheet.dart';

class AddPlaceButton extends ConsumerWidget {
  final String label;
  final VoidCallback? onPressed;

  const AddPlaceButton({
    super.key,
    this.label = 'Thêm địa điểm',
    this.onPressed,
  });

  void _openAddPlaceBottomSheet(
    final BuildContext context,
    final WidgetRef ref,
  ) {
    final dayId = ref.read(
      itineraryScheduleControllerProvider.select(
        (final state) => state.selectedDayId,
      ),
    );

    if (dayId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa chọn ngày để thêm địa điểm')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final context) => const FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(),
      ),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: onPressed ?? () => _openAddPlaceBottomSheet(context, ref),
          icon: const Icon(Icons.add_location_alt_outlined, size: 20),
          label: Text(label),
        ),
      ),
    );
  }
}
