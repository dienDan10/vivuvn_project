import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'widgets/btn_add_itinerary.dart';
import 'widgets/itinerary_list.dart';

class ItineraryListLayout extends StatelessWidget {
  const ItineraryListLayout({super.key});

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: const SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  'Chuyến đi',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              TabBar(
                isScrollable: false,
                tabs: [
                  Tab(text: 'Chuyến đi của tôi'),
                  Tab(text: 'Chuyến đi tôi tham gia'),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  children: [
                    ItineraryList(isOwner: true),
                    ItineraryList(isOwner: false),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const ButtonAddItinerary(),
        floatingActionButtonLocation: ExpandableFab.location,
      ),
    );
  }
}
