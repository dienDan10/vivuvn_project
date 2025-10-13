import 'package:flutter/material.dart';

class AddPlaceButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddPlaceButton({super.key, required this.onPressed});

  @override
  Widget build(final BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_location_alt_outlined),
      label: const Text('Thêm địa điểm'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
