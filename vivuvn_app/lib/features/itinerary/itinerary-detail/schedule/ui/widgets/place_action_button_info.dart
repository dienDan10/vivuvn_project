import 'package:flutter/material.dart';

import '../../../../location-detail/ui/location_detail_screen.dart';
import '../../model/location.dart';

class PlaceActionButtonInfo extends StatelessWidget {
  final Location location;
  const PlaceActionButtonInfo({super.key, required this.location});

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LocationDetailScreen(locationId: location.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: colorScheme.onPrimary),
            const SizedBox(width: 8),
            Text(
              'Thông tin',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
