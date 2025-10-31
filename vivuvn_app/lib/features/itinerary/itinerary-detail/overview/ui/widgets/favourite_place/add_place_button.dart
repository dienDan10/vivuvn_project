import 'package:flutter/material.dart';

import 'add_place_modal.dart';

class AddPlaceButton extends StatelessWidget {
  const AddPlaceButton({super.key});

  void _showAddPlaceModal(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => const AddPlaceModal(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: OutlinedButton(
        onPressed: () => _showAddPlaceModal(context),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Thêm địa điểm yêu thích',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
