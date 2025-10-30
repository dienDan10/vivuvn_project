import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../itinerary/itinerary-detail/detail/ui/btn_back.dart';
import '../../login/ui/widgets/loading_overlay.dart';
import '../controller/hotel_controller.dart';
import 'widgets/hotel_carousel.dart';
import 'widgets/map_hotel.dart';

class NearbyHotelLayout extends ConsumerStatefulWidget {
  const NearbyHotelLayout({super.key});

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
          const MapHotel(),

          // Back Button
          const Positioned(top: 50, left: 16, child: ButtonBack()),

          // Restaurant Carousel
          const HotelCarousel(),

          // Loading overlay
          if (isLoading) const LoadingOverlay(loadingText: 'Lấy dữ liệu...'),
        ],
      ),
    );
  }
}
