import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/restaurant_controller.dart';
import 'restaurant_carousel_item.dart';

class RestaurantCarousel extends ConsumerStatefulWidget {
  const RestaurantCarousel({super.key});

  @override
  ConsumerState<RestaurantCarousel> createState() => _RestaurantCarouselState();
}

class _RestaurantCarouselState extends ConsumerState<RestaurantCarousel> {
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(final BuildContext context) {
    final restaurants = ref.watch(
      restaurantControllerProvider.select((final state) => state.restaurants),
    );

    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
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
        ),
        itemCount: restaurants.length,
        itemBuilder:
            (final BuildContext context, final int itemIndex, final int _) {
              final restaurant = restaurants[itemIndex];
              return RestaurantCarouselItem(restaurant: restaurant);
            },
      ),
    );
  }
}
