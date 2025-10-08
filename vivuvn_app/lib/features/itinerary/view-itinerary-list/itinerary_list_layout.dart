import 'package:flutter/material.dart';

import 'ui/btn_add_itinerary.dart';
import 'ui/itinerary_list.dart';

class ItineraryListLayout extends StatelessWidget {
  const ItineraryListLayout({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Itineraries',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),

            // Itinerary list
            Expanded(child: ItineraryList()),
          ],
        ),
      ),
      floatingActionButton: ButtonAddItinerary(),
    );
  }
}
