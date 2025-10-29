import 'package:flutter/material.dart';

import '../../location/ui/location_detail_screen.dart';
import '../../model/location.dart';

class PlaceActionButtonInfo extends StatelessWidget {
  final Location location;
  const PlaceActionButtonInfo({super.key, required this.location});

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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LocationDetailScreen(locationId: location.id),
          ),
        );
      },
      icon: const Icon(Icons.info_outline, size: 20),
      label: const Text(
        'Thông tin',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
