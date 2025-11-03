import 'package:flutter/material.dart';

import 'join_itinerary_background.dart';
import 'join_itinerary_sheet.dart';

class JoinItineraryModal extends StatelessWidget {
  const JoinItineraryModal({super.key});

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        const JoinItineraryBackground(),
        DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (final context, final scrollController) {
            return JoinItinerarySheet(scrollController: scrollController);
          },
        ),
      ],
    );
  }
}


