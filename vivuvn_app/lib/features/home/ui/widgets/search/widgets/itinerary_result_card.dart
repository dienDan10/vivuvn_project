import 'package:flutter/material.dart';

import '../../../../data/dto/itinerary_dto.dart';

class ItineraryResultCard extends StatelessWidget {
  final ItineraryDto itinerary;

  const ItineraryResultCard({required this.itinerary, super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final dateRange = itinerary.formattedDateRange;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: SizedBox(
                width: 130,
                height: 140,
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
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itinerary.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (itinerary.startProvinceName.isNotEmpty)
                      _buildProvinceRow(
                        context,
                        icon: Icons.flight_takeoff,
                        label: itinerary.startProvinceName,
                      ),
                    if (itinerary.startProvinceName.isNotEmpty &&
                        itinerary.destinationProvinceName.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Icon(
                          Icons.arrow_downward,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                    if (itinerary.destinationProvinceName.isNotEmpty)
                      _buildProvinceRow(
                        context,
                        icon: Icons.flight_land,
                        label: itinerary.destinationProvinceName,
                      ),
                    const Spacer(),
                    Text(
                      dateRange,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildProvinceRow(
    final BuildContext context, {
    required final IconData icon,
    required final String label,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

