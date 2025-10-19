import 'package:flutter/material.dart';

class PlaceIcon extends StatelessWidget {
  const PlaceIcon({super.key, this.opacity = 1.0});

  final double opacity;

  @override
  Widget build(final BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.place, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
