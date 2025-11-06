import 'package:flutter/material.dart';

import 'btn_join_itinerary.dart';

class JoinActionButtonWrapper extends StatelessWidget {
  const JoinActionButtonWrapper({super.key});

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 48,
      child: Center(
        child: SizedBox.expand(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const JoinItineraryButton(),
          ),
        ),
      ),
    );
  }
}


