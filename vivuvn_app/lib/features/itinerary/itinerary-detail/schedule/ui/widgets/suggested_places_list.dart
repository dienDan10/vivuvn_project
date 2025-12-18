import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
import '../../controller/itinerary_schedule_controller.dart';
import '../../model/location.dart';
import 'suggested_place_item.dart';

class SuggestedPlacesList extends ConsumerWidget {
  const SuggestedPlacesList({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.isOwner ?? false,
      ),
    );

    // Ẩn phần gợi ý nếu không phải owner
    if (!isOwner) {
      return const SizedBox.shrink();
    }

    final suggestions = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.suggestedLocations,
      ),
    );

    final isAddingLocation = ref.watch(
      itineraryScheduleControllerProvider.select(
        (final state) => state.isAddingLocation,
      ),
    );

    return Stack(
      children: [
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: suggestions.length,
            separatorBuilder: (_, final __) => const SizedBox(width: 16),
            itemBuilder: (final context, final index) {
              final location = suggestions[index];
              final firstPhoto = _firstPhoto(location);

              return SuggestedPlaceItem(
                key: ValueKey(location.id),
                locationId: location.id,
                title: location.name,
                imageUrl: firstPhoto,
                onTap: isAddingLocation
                    ? null
                    : () async {
                        final controller = ref.read(
                          itineraryScheduleControllerProvider.notifier,
                        );

                        final result = await controller
                            .addLocationToSelectedDay(
                              locationId: location.id,
                              locationName: location.name,
                            );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(result.message)));
                      },
              );
            },
          ),
        ),
        if (isAddingLocation)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  String? _firstPhoto(final Location location) =>
      location.photos.isNotEmpty ? location.photos.first : null;
}
