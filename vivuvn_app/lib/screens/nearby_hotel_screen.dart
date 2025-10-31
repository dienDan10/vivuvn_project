import 'package:flutter/material.dart';

import '../features/itinerary/itinerary-detail/schedule/model/location.dart';
import '../features/itinerary/view-nearby-hotel/ui/neaby_hotel_layout.dart';

class NearbyHotelScreen extends StatelessWidget {
  final Location location;
  const NearbyHotelScreen({super.key, required this.location});

  @override
  Widget build(final BuildContext context) {
    return NearbyHotelLayout(location: location);
  }
}
