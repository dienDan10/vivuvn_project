import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_itinerary_provider.dart';

class ItineraryImage extends ConsumerWidget {
  const ItineraryImage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final itinerary = ref.watch(currentItineraryProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/image-placeholder.jpeg',
        image: itinerary.imageUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        imageErrorBuilder: (final context, final error, final stackTrace) {
          return Image.asset(
            'assets/images/image-placeholder.jpeg',
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}


