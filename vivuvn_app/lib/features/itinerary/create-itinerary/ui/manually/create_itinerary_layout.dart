import 'package:flutter/material.dart';

import 'widgets/create_itinerary_form.dart';
import 'widgets/create_itinerary_header.dart';

class CreateItineraryLayout extends StatelessWidget {
  const CreateItineraryLayout({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: kToolbarHeight + MediaQuery.of(context).padding.top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const CreateItineraryHeader(),
          const SizedBox(height: 20),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Tạo một hành trình để bắt đầu khám phá các điểm đến tuyệt vời!',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          // Create Itinerary Form
          const Expanded(child: CreateItineraryForm()),
        ],
      ),
    );
  }
}
