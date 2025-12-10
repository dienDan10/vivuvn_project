import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/routes/routes.dart';
import '../../../../../itinerary/itinerary-detail/detail/service/itinerary_detail_service.dart';
import '../../../../data/dto/itinerary_dto.dart';

class ItineraryResultCard extends ConsumerWidget {
  final ItineraryDto itinerary;

  const ItineraryResultCard({required this.itinerary, super.key});

  Future<void> _handleTap(final BuildContext context, final WidgetRef ref) async {
    final itineraryId = int.tryParse(itinerary.id);

    final isAllowedToViewDetail = itinerary.isMember || itinerary.isOwner;

    if (isAllowedToViewDetail && itineraryId != null) {
      context.push(createItineraryDetailRoute(itineraryId));
      return;
    }

    // Fallback: nếu list item không có isMember/isOwner đúng, gọi detail để kiểm tra lại
    if (itineraryId != null) {
      try {
        final detailService = ref.read(itineraryDetailServiceProvider);
        final detail = await detailService.getItineraryDetail(itineraryId);
        final allowFromDetail = detail.isMember || detail.isOwner;

        if (allowFromDetail) {
          if (context.mounted) {
            context.push(createItineraryDetailRoute(itineraryId));
          }
          return;
        }
      } catch (e) {
        // Error handled silently
      }
    }

    context.push(createPublicItineraryViewRoute(itinerary.id));
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final dateRange = itinerary.formattedDateRange;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _handleTap(context, ref),
        borderRadius: BorderRadius.circular(12),
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

