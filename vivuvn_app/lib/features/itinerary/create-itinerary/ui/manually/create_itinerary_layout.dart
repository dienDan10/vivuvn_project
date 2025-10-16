import 'package:flutter/material.dart';

import 'widgets/create_itinerary_form.dart';

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'Create Your New Itinerary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Plan and organize your next adventure!',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Create Itinerary Form
            const CreateItineraryForm(),
          ],
        ),
      ),
    );
  }
}
