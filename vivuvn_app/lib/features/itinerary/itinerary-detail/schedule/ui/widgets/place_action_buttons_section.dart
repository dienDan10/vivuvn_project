import 'package:flutter/material.dart';

import '../../model/location.dart';
import 'place_action_button_direction.dart';
import 'place_action_button_info.dart';
import 'place_action_button_location.dart';
import 'place_action_button_website.dart';

class PlaceActionButtonsSection extends StatelessWidget {
  const PlaceActionButtonsSection({super.key, required this.location});

  final Location location;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          PlaceActionButtonInfo(location: location),
          const SizedBox(width: 8),
          const PlaceActionButtonLocation(),
          const SizedBox(width: 8),
          const PlaceActionButtonDirection(),
          const SizedBox(width: 8),
          const PlaceActionButtonWebsite(),
        ],
      ),
    );
  }
}
