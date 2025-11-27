import 'package:flutter/material.dart';

import 'place_card_content.dart';
import 'place_card_image.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    required this.title,
    required this.description,
    this.imageUrl,
    this.index,
    this.placeUri,
    this.directionsUri,
    this.locationQuery,
    super.key,
  });

  final String title;
  final String description;
  final String? imageUrl;
  final int? index;
  final String? placeUri;
  final String? directionsUri;
  final String? locationQuery;

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: PlaceCardContent(
              title: title,
              description: description,
              index: index,
              placeUri: placeUri,
              directionsUri: directionsUri,
              locationQuery: locationQuery,
            ),
          ),
          const SizedBox(width: 12),
          PlaceCardImage(imageUrl: imageUrl, size: 80),
        ],
      ),
    );
  }
}
