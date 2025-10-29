import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../itinerary/itinerary-detail/ui/btn_back.dart';
import '../../login/ui/widgets/loading_overlay.dart';
import '../controller/restaurant_controller.dart';
import 'widgets/map_restaurant.dart';
import 'widgets/restaurant_carousel.dart';

class NearbyRestaurantLayout extends ConsumerStatefulWidget {
  const NearbyRestaurantLayout({super.key});

  @override
  ConsumerState<NearbyRestaurantLayout> createState() =>
      _NearbyRestaurantLayoutState();
}

class _NearbyRestaurantLayoutState
    extends ConsumerState<NearbyRestaurantLayout> {
  @override
  Widget build(final BuildContext context) {
    final bool isLoading = ref.watch(
      restaurantControllerProvider.select((final state) => state.isLoading),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Map Widget
          const MapRestaurant(),

          // Back Button
          const Positioned(top: 50, left: 16, child: ButtonBack()),

          // Restaurant Carousel
          const RestaurantCarousel(),

          // Loading overlay
          if (isLoading) const LoadingOverlay(loadingText: 'Lấy dữ liệu...'),
        ],
      ),
    );
  }
}
