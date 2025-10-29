import 'package:flutter/material.dart';

import 'place_card_description.dart';
import 'place_card_header.dart';

class PlaceCardContent extends StatelessWidget {
  const PlaceCardContent({
    required this.title,
    required this.description,
    this.index,
    super.key,
  });

  final String title;
  final String description;
  final int? index;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceCardHeader(title: title, index: index),
        const SizedBox(height: 6),
        PlaceCardDescription(description: description),
      ],
    );
  }
}
