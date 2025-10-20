import 'package:flutter/material.dart';

class TransportSection extends StatelessWidget {
  const TransportSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        const Icon(Icons.directions_car, color: Colors.black54),
        const SizedBox(width: 8),
        Text(
          '45 mins',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Đường đi',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
