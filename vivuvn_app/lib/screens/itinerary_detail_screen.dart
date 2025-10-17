import 'package:flutter/material.dart';

import '../features/itinerary/itinerary-detail/ui/itinerary_detail_layout.dart';

class ItineraryDetailScreen extends StatelessWidget {
  final int itineraryId;
  const ItineraryDetailScreen({super.key, required this.itineraryId});

  @override
  Widget build(final BuildContext context) {
    return ItineraryDetailLayout(itineraryId: itineraryId);
  }
}
