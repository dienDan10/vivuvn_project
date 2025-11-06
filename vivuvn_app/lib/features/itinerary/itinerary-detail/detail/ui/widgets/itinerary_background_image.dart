import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';

class ItineraryBackgroundImage extends ConsumerWidget {
  const ItineraryBackgroundImage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final imageUrl = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.imageUrl ?? '',
      ),
    );

    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.2),
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (final context, final error, final stackTrace) =>
            Image.asset(
          'assets/images/images-placeholder.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

