import 'package:flutter/material.dart';

class ButtonAddItinerary extends StatelessWidget {
  const ButtonAddItinerary({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
