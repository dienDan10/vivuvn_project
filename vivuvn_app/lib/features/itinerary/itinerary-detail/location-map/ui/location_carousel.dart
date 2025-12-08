import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/map_location_controller.dart';
import 'location_carousel_item.dart';

class LocationCarousel extends ConsumerStatefulWidget {
  const LocationCarousel({super.key});

  @override
  ConsumerState<LocationCarousel> createState() => _LocationCarouselState();
}

class _LocationCarouselState extends ConsumerState<LocationCarousel> {
  CarouselSliderController carouselController = CarouselSliderController();

  void _onCarouselPageChanged(
    final int index,
    final CarouselPageChangedReason reason,
  ) {
    if (reason == CarouselPageChangedReason.manual) {
      // Only update when the change is manual (user swiped)
      ref
          .read(mapLocationControllerProvider.notifier)
          .setCurrentItemIndex(index);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final selectedDayIndex = ref.watch(
      mapLocationControllerProvider.select(
        (final state) => state.selectedDayIndex,
      ),
    );

    ref.listen(
      mapLocationControllerProvider.select(
        (final state) => state.currentItemIndex,
      ),
      (final previous, final next) async {
        if (previous == next) return;
        await carouselController.animateToPage(next);
      },
    );

    final selectedDay = ref.read(
      mapLocationControllerProvider.select(
        (final state) =>
            state.days.isNotEmpty ? state.days[selectedDayIndex] : null,
      ),
    );

    final items = selectedDay?.items ?? [];

    if (items.isEmpty) {
      return Positioned(
        bottom: 40,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.shadow.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Không có địa điểm nào trong ngày này',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: CarouselSlider.builder(
        carouselController: carouselController,
        options: CarouselOptions(
          height: 180,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          viewportFraction: 0.9,
          enlargeFactor: 0.2,
          onPageChanged: _onCarouselPageChanged,
        ),
        itemCount: items.length,
        itemBuilder:
            (final BuildContext context, final int itemIndex, final int _) {
              final item = items[itemIndex];
              return LocationCarouselItem(
                location: item.location,
                index: itemIndex,
                key: ValueKey(item.location.id),
              );
            },
      ),
    );
  }
}
