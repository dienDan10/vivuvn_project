import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/itinerary_detail_controller.dart';
import 'add_place_bottom_sheet.dart';

class AddPlaceButton extends ConsumerWidget {
  final String label;
  final VoidCallback? onPressed;
  final int dayId;

  const AddPlaceButton({
    super.key,
    required this.dayId,
    this.label = 'Thêm địa điểm',
    this.onPressed,
  });

  void _openAddPlaceBottomSheet(
    final BuildContext context,
    final WidgetRef ref,
  ) {
    final itineraryId = ref.read(itineraryDetailControllerProvider).itineraryId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(dayId: dayId, itineraryId: itineraryId!),
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
