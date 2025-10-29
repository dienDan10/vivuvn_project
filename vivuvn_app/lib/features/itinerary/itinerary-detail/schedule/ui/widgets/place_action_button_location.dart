import 'package:flutter/material.dart';

class PlaceActionButtonLocation extends StatelessWidget {
  const PlaceActionButtonLocation({super.key});

  @override
  Widget build(final BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: () {},
      icon: const Icon(Icons.location_on_outlined, size: 20),
      label: const Text(
        'Vị trí',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
