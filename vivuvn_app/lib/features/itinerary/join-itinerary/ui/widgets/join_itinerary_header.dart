import 'package:flutter/material.dart';

class JoinItineraryHeader extends StatelessWidget {
  const JoinItineraryHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 48), // balance for symmetry
          Expanded(
            child: Text(
              'Tham gia chuyến đi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}


