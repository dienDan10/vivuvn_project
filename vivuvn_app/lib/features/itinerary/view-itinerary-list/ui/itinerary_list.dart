import 'package:flutter/material.dart';

import '../models/itinerary.dart';
import 'itinerary_list_item.dart';

class ItineraryList extends StatelessWidget {
  const ItineraryList({super.key});

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      itemCount: dummyItineraries.length,
      itemBuilder: (final ctx, final index) {
        return ItineraryListItem(itinerary: dummyItineraries[index]);
      },
    );
  }
}
