import 'package:flutter/material.dart';

import 'widgets/create_itinerary_form.dart';

class CreateItineraryModal extends StatelessWidget {
  const CreateItineraryModal({super.key});

  @override
  Widget build(final BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (final notification) {
        // Unfocus để ẩn bàn phím khi user drag modal
        FocusScope.of(context).unfocus();
        return false;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (final context, final scrollController) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 20),
                  // Create Itinerary Form
                  CreateItineraryForm(scrollController: scrollController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
