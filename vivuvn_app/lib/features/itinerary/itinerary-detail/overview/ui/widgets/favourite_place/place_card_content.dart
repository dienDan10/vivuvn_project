import 'package:flutter/material.dart';

import '../shared/location_action_buttons.dart';
import 'place_card_description.dart';
import 'place_card_header.dart';

class PlaceCardContent extends StatelessWidget {
  const PlaceCardContent({
    required this.title,
    required this.description,
    this.index,
    this.placeUri,
    this.directionsUri,
    this.locationQuery,
    super.key,
  });

  final String title;
  final String description;
  final int? index;
  final String? placeUri;
  final String? directionsUri;
  final String? locationQuery;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceCardHeader(title: title, index: index),
        const SizedBox(height: 6),
        PlaceCardDescription(description: description),
        LocationActionButtons(
          placeUri: placeUri,
          directionsUri: directionsUri,
          fallbackQuery: locationQuery,
        ),
      ],
    );
  }
}
