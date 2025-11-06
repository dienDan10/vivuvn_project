import 'package:flutter/material.dart';

// import 'widgets/btn_join_itinerary.dart';
import 'widgets/join_itinerary_form.dart';

class JoinItineraryContent extends StatelessWidget {
  final ScrollController scrollController;

  const JoinItineraryContent({super.key, required this.scrollController});

  @override
  Widget build(final BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            JoinItineraryForm(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


