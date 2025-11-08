import 'package:flutter/material.dart';

class JoinItineraryBackground extends StatelessWidget {
  const JoinItineraryBackground({super.key});

  @override
  Widget build(final BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}


