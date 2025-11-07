import 'package:flutter/material.dart';

class SuggestedPlacesLoading extends StatelessWidget {
  const SuggestedPlacesLoading({super.key});

  @override
  Widget build(final BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: CircularProgressIndicator(),
      );
}

