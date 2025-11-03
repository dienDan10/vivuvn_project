import 'package:flutter/material.dart';

class JoinItineraryDragHandle extends StatelessWidget {
  const JoinItineraryDragHandle({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 4),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}


