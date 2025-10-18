import 'package:flutter/material.dart';

import 'add_place_modal.dart';

class AddPlaceButton extends StatelessWidget {
  const AddPlaceButton({required this.itineraryId, super.key});

  final int itineraryId;

  void _showAddPlaceModal(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => AddPlaceModal(itineraryId: itineraryId),
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
          onPressed: () => _showAddPlaceModal(context),
          icon: const Icon(Icons.add_location_alt_outlined, size: 20),
          label: const Text('Thêm địa điểm yêu thích'),
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
