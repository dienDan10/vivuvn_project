import 'package:flutter/material.dart';

import '../state/public_itinerary_state.dart';
import 'widgets/public_itinerary_header.dart';
import 'widgets/sections/hotel_section.dart';
import 'widgets/sections/itinerary_day_list.dart';
import 'widgets/sections/restaurant_section.dart';

class PublicItineraryLayout extends StatelessWidget {
  final PublicItineraryState state;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const PublicItineraryLayout({
    required this.state,
    required this.onBack,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final itinerary = state.itinerary!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Lịch trình'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (final String value) {
              if (value == 'join') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tính năng tham gia lịch trình đang được phát triển'),
                  ),
                );
              }
            },
            itemBuilder: (final BuildContext context) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'join',
                child: Row(
                  children: [
                    Icon(Icons.person_add, size: 20),
                    SizedBox(width: 12),
                    Text('Tham gia lịch trình'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          PublicItineraryHeader(itinerary: itinerary, members: state.members),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => onRetry(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.days.isNotEmpty)
                      ItineraryDayList(days: state.days),
                    if (state.restaurants.isNotEmpty)
                      RestaurantSection(restaurants: state.restaurants),
                    if (state.hotels.isNotEmpty)
                      HotelSection(hotels: state.hotels),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

