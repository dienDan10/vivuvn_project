import 'package:flutter/material.dart';

import 'add_place_bottom_sheet.dart';

class AddPlaceButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final int itineraryId;
  final int dayId;

  const AddPlaceButton({
    super.key,
    required this.itineraryId,
    required this.dayId,
    this.label = 'Thêm địa điểm',
    this.onPressed,
  });

  void _openAddPlaceBottomSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(itineraryId: itineraryId, dayId: dayId),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: onPressed ?? () => _openAddPlaceBottomSheet(context),
          icon: const Icon(Icons.add_location_alt_outlined, size: 20),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
