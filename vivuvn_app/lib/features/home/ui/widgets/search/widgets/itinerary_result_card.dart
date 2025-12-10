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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360 || screenHeight < 700;
    
    // Responsive dimensions
    final cardHeight = isSmallScreen ? 110.0 : 140.0;
    final imageWidth = isSmallScreen ? screenWidth * 0.28 : 130.0;
    final horizontalPadding = isSmallScreen ? 8.0 : 12.0;
    final verticalPadding = isSmallScreen ? 8.0 : 12.0;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _handleTap(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
        height: cardHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: SizedBox(
                width: imageWidth,
                height: cardHeight,
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
            SizedBox(width: horizontalPadding),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: verticalPadding),
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
                        fontSize: isSmallScreen ? 14 : null,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    if (itinerary.startProvinceName.isNotEmpty)
                      _buildProvinceRow(
                        context,
                        icon: Icons.place,
                        label: itinerary.startProvinceName,
                        isSmallScreen: isSmallScreen,
                      ),
                    if (itinerary.startProvinceName.isNotEmpty &&
                        itinerary.destinationProvinceName.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 1 : 2),
                        child: Icon(
                          Icons.arrow_downward,
                          size: isSmallScreen ? 12 : 14,
                          color: Colors.grey,
                        ),
                      ),
                    if (itinerary.destinationProvinceName.isNotEmpty)
                      _buildProvinceRow(
                        context,
                        icon: Icons.place,
                        label: itinerary.destinationProvinceName,
                        isSmallScreen: isSmallScreen,
                      ),
                    const Spacer(),
                    Text(
                      dateRange,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                        fontSize: isSmallScreen ? 11 : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: horizontalPadding),
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
    required final bool isSmallScreen,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: isSmallScreen ? 14 : 16,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: isSmallScreen ? 4 : 6),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: isSmallScreen ? 12 : null,
            ),
          ),
        ),
      ],
    );
  }
}

