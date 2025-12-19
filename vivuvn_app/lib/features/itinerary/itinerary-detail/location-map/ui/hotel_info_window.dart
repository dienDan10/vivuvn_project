import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../overview/data/dto/hotel_item_response.dart';

class HotelInfoWindow extends StatelessWidget {
  final HotelItemResponse hotel;
  const HotelInfoWindow({super.key, required this.hotel});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (hotel.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: hotel.imageUrl!,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (final context, final url) => Container(
                  height: 100,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (final context, final url, final error) =>
                    Container(
                      height: 100,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.hotel,
                        size: 32,
                        color: theme.colorScheme.outline,
                      ),
                    ),
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hotel icon and name
                Row(
                  children: [
                    Icon(
                      Icons.hotel,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        hotel.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hotel.address,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Check-in and check-out dates

                // Note
              ],
            ),
          ),
        ],
      ),
    );
  }
}
