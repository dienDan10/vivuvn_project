import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/routes.dart';
import '../../../itinerary/itinerary-detail/detail/service/itinerary_detail_service.dart';
import '../../data/dto/itinerary_dto.dart';

class ItineraryCard extends ConsumerWidget {
  final ItineraryDto itinerary;

  const ItineraryCard({required this.itinerary, super.key});

  Future<void> _handleTap(final BuildContext context, final WidgetRef ref) async {
    final itineraryId = int.tryParse(itinerary.id);

    final isAllowedToViewDetail = itinerary.isMember || itinerary.isOwner;

    debugPrint(
      'ItineraryCard tap - id: ${itinerary.id}, parsedId: $itineraryId, '
      'isOwner: ${itinerary.isOwner}, isMember: ${itinerary.isMember}, '
      'route: ${isAllowedToViewDetail && itineraryId != null ? 'detail' : 'public'}',
    );

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

        debugPrint(
          'ItineraryCard tap - fallback detail check id: $itineraryId, '
          'detail.isOwner: ${detail.isOwner}, detail.isMember: ${detail.isMember}, '
          'route: ${allowFromDetail ? 'detail' : 'public'}',
        );

        if (allowFromDetail) {
          if (context.mounted) {
            context.push(createItineraryDetailRoute(itineraryId));
          }
          return;
        }
      } catch (e) {
        debugPrint('ItineraryCard tap - fallback detail error: $e');
      }
    }

    context.push(createPublicItineraryViewRoute(itinerary.id));
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _handleTap(context, ref),
          borderRadius: BorderRadius.circular(12),
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
                    // Top overlay - Date, Province, and Owner info
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.black.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Public badge
                                if (itinerary.isPublic)
                                  Container(
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
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Date
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  itinerary.formattedDateRange,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Province
                            Row(
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Owner info
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                                  backgroundImage: itinerary.owner.avatarUrl != null
                                      ? NetworkImage(itinerary.owner.avatarUrl!)
                                      : null,
                                  child: itinerary.owner.avatarUrl == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    itinerary.owner.name,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom overlay - Title with better background
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                itinerary.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
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
                                        '${itinerary.currentMemberCount}/${itinerary.groupSize} người',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.white),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
