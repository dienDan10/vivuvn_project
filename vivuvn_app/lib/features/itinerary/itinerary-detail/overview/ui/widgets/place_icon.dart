import 'package:flutter/material.dart';

class PlaceIcon extends StatelessWidget {
  const PlaceIcon({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.place, color: Theme.of(context).colorScheme.primary),
    );
  }
}
