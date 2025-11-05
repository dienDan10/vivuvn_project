import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/hotel_controller.dart';
import 'hotel_carousel_item.dart';

class HotelCarousel extends ConsumerStatefulWidget {
  const HotelCarousel({super.key});

  @override
  ConsumerState<HotelCarousel> createState() => _HotelCarouselState();
}

class _HotelCarouselState extends ConsumerState<HotelCarousel> {
  CarouselSliderController carouselController = CarouselSliderController();

  void _onCarouselPageChanged(
    final int index,
    final CarouselPageChangedReason reason,
  ) {
    ref.read(hotelControllerProvider.notifier).setCurrentHotelIndex(index);
  }

  @override
  Widget build(final BuildContext context) {
    final hotels = ref.watch(
      hotelControllerProvider.select((final state) => state.hotels),
    );

    if (hotels.isEmpty) {
      return const SizedBox.shrink();
    }

    ref.listen(
      hotelControllerProvider.select((final state) => state.currentHotelIndex),
      (final prev, final next) async {
        if (prev == next) return;
        await carouselController.animateToPage(next);
      },
    );
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
        itemCount: hotels.length,
        itemBuilder:
            (final BuildContext context, final int itemIndex, final int _) {
              final hotel = hotels[itemIndex];
              return HotelCarouselItem(hotel: hotel);
            },
      ),
    );
  }
}
