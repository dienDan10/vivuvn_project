import 'package:flutter/material.dart';

import '../features/itinerary/itinerary-detail/schedule/model/location.dart';
import '../features/itinerary/view-nearby-restaurant/ui/nearby_restaurant_layout.dart';

class NearbyRestaurantScreen extends StatelessWidget {
  final Location location;
  const NearbyRestaurantScreen({super.key, required this.location});

  @override
  Widget build(final BuildContext context) {
    return NearbyRestaurantLayout(location: location);
  }
}
