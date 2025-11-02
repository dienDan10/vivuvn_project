import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../login/ui/widgets/loading_overlay.dart';
import '../../itinerary-detail/detail/ui/btn_back.dart';
import '../../itinerary-detail/schedule/model/location.dart';
import '../controller/restaurant_controller.dart';
import 'widgets/location_header.dart';
import 'widgets/map_restaurant.dart';
import 'widgets/restaurant_carousel.dart';

class NearbyRestaurantLayout extends ConsumerStatefulWidget {
  final Location location;
  const NearbyRestaurantLayout({super.key, required this.location});

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
          MapRestaurant(location: widget.location),

          // Back Button
          const Positioned(top: 50, left: 16, child: ButtonBack()),

          // Location Header
          LocationHeader(locationName: widget.location.name),

          // Restaurant Carousel
          const RestaurantCarousel(),

          // Loading overlay
          if (isLoading) const LoadingOverlay(loadingText: 'Lấy dữ liệu...'),
        ],
      ),
    );
  }
}
