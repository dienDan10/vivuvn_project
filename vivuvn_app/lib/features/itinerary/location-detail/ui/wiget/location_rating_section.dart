import 'package:flutter/material.dart';

class LocationRatingSection extends StatelessWidget {
  final double rating;
  final int ratingCount;

  const LocationRatingSection({
    super.key,
    required this.rating,
    required this.ratingCount,
  });

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Row(
            children: List.generate(5, (final index) {
              IconData icon;
              if (index < rating.floor()) {
                icon = Icons.star;
              } else if (index < rating && rating - index >= 0.5) {
                icon = Icons.star_half;
              } else {
                icon = Icons.star_border;
              }
              return Icon(icon, color: Colors.amber.shade700, size: 22);
            }),
          ),
          const SizedBox(width: 10),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          const Text('/5', style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 10),
          Row(
            children: [
              const Icon(
                Icons.people_alt_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 3),
              Text(
                '$ratingCount',
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
