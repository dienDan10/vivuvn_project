import 'package:flutter/material.dart';

import '../../schedule/model/location.dart';

class LocationCarouselItem extends StatelessWidget {
  final Location location;
  final int index;
  const LocationCarouselItem({
    super.key,
    required this.location,
    required this.index,
  });

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Image with order badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/image-placeholder.jpeg',
                      image: location.photos.isNotEmpty
                          ? location.photos[0]
                          : 'assets/images/image-placeholder.jpeg',
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      imageErrorBuilder:
                          (final context, final error, final stackTrace) {
                            return Image.asset(
                              'assets/images/image-placeholder.jpeg',
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            );
                          },
                    ),
                  ),
                  // Order badge
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: colorScheme.onPrimary,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '#${index + 1}',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Location Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Rating row
                    Row(
                      children: [
                        Icon(Icons.star, color: colorScheme.tertiary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          location.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.tertiary,
                          ),
                        ),
                        if (location.ratingCount != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${location.ratingCount})',
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Address row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.place_outlined,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location.address,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Buttons Group
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Directions Button
                if (location.directionsUri != null)
                  OutlinedButton.icon(
                    onPressed: () {
                      // Open directions in maps
                    },
                    icon: Icon(
                      Icons.directions,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    label: Text(
                      'Chỉ đường',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),

                // Details Button
                FilledButton.icon(
                  onPressed: () {
                    // Show location details
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Chi tiết', style: TextStyle(fontSize: 13)),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
