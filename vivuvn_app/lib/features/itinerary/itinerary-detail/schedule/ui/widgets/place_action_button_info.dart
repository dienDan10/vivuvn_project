import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/routes/routes.dart';
import '../../model/location.dart';

class PlaceActionButtonInfo extends StatelessWidget {
  final Location location;
  const PlaceActionButtonInfo({super.key, required this.location});

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        context.push(createLocationDetailRoute(location.id));
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
