import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
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
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.isOwner ?? false,
      ),
    );

    if (!isOwner) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onPressed ?? () => _openAddPlaceBottomSheet(context, ref),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location_alt_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
