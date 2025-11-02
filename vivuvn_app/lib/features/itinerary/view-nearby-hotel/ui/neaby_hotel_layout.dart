import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../login/ui/widgets/loading_overlay.dart';
import '../../itinerary-detail/detail/ui/btn_back.dart';
import '../../itinerary-detail/schedule/model/location.dart';
import '../../view-nearby-restaurant/ui/widgets/location_header.dart';
import '../controller/hotel_controller.dart';
import 'widgets/hotel_carousel.dart';
import 'widgets/map_hotel.dart';

class NearbyHotelLayout extends ConsumerStatefulWidget {
  final Location location;
  const NearbyHotelLayout({super.key, required this.location});

  @override
  ConsumerState<NearbyHotelLayout> createState() => _NearbyHotelLayoutState();
}

class _NearbyHotelLayoutState extends ConsumerState<NearbyHotelLayout> {
  @override
  Widget build(final BuildContext context) {
    final bool isLoading = ref.watch(
      hotelControllerProvider.select((final state) => state.isLoading),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Map Widget
          MapHotel(location: widget.location),

          // Back Button
          const Positioned(top: 50, left: 16, child: ButtonBack()),

          // Location Header
          LocationHeader(locationName: widget.location.name),

          // Restaurant Carousel
          const HotelCarousel(),

          // Loading overlay
          if (isLoading) const LoadingOverlay(loadingText: 'Lấy dữ liệu...'),
        ],
      ),
    );
  }
}
