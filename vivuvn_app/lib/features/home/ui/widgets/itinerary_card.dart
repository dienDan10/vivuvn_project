import 'package:flutter/material.dart';

import '../../data/dto/itinerary_dto.dart';

class ItineraryCard extends StatelessWidget {
  final ItineraryDto itinerary;

  const ItineraryCard({required this.itinerary, super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay content
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: Image.network(
                        itinerary.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (final context, final error, final stackTrace) =>
                                Image.asset(
                                  'assets/images/images-placeholder.jpeg',
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Public badge
                    if (itinerary.isPublic)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.public,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Công khai',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Content overlay
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            itinerary.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        itinerary.destination,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.group,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${itinerary.participantCount} người',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        itinerary.formattedDateRange,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${itinerary.durationDays} ngày',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Owner info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                    backgroundImage: itinerary.owner.avatarUrl != null
                        ? NetworkImage(itinerary.owner.avatarUrl!)
                        : null,
                    child: itinerary.owner.avatarUrl == null
                        ? Icon(
                            Icons.person,
                            size: 14,
                            color: colorScheme.primary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    itinerary.owner.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
