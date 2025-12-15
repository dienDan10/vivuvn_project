import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../itinerary/itinerary-detail/schedule/model/transportation_mode.dart';
import '../../controller/public_itinerary_controller.dart';
import 'header/info_column.dart';
import 'header/location_info_column.dart';

class PublicItineraryHeader extends ConsumerWidget {
  const PublicItineraryHeader({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(publicItineraryControllerProvider);
    final itinerary = state.itinerary;
    if (itinerary == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Image.network(
            itinerary.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (final context, final error, final stackTrace) => Container(
              color: colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image, size: 64),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 60),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    itinerary.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: LocationInfoColumn(
                          startProvinceName: itinerary.startProvinceName,
                          destinationProvinceName: itinerary.destinationProvinceName,
                          secondaryIcon: Icons.calendar_today,
                          secondaryLabel:
                              '${DateFormat('dd/MM/yyyy').format(itinerary.startDate)} - ${DateFormat('dd/MM/yyyy').format(itinerary.endDate)}',
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InfoColumn(
                          avatarUrl: itinerary.owner.userPhoto,
                          label: itinerary.owner.username,
                          subtitle: itinerary.owner.email,
                          icon: itinerary.transportationVehicle.isNotEmpty
                              ? TransportationMode.getIcon(itinerary.transportationVehicle)
                              : Icons.directions,
                          secondaryLabel: itinerary.transportationVehicle.isNotEmpty
                              ? itinerary.transportationVehicle
                              : 'Chưa cập nhật',
                          tertiaryIcon: Icons.group,
                          tertiaryLabel: '${itinerary.currentMemberCount}/${itinerary.groupSize} người',
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


