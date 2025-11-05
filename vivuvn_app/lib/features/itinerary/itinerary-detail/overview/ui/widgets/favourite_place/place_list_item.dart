import 'package:flutter/material.dart';

import '../../../data/dto/favourite_places_response.dart';
import 'add_place_button.dart';
import 'animated_place_card.dart';
import 'place_list_header.dart';

class PlaceListItem extends StatelessWidget {
  const PlaceListItem({
    required this.index,
    required this.places,
    required this.isExpanded,
    required this.iconRotationAnimation,
    required this.onToggle,
    super.key,
  });

  final int index;
  final List<FavouritePlacesResponse> places;
  final bool isExpanded;
  final Animation<double> iconRotationAnimation;
  final VoidCallback onToggle;

  @override
  Widget build(final BuildContext context) {
    // Header với toggle button
    if (index == 0) {
      return PlaceListHeader(
        placesCount: places.length,
        isExpanded: isExpanded,
        iconRotationAnimation: iconRotationAnimation,
        onToggle: onToggle,
      );
    }

    // Nếu đang thu gọn, chỉ hiển thị bottom spacing
    if (!isExpanded) {
      if (index == 1) {
        return const SizedBox(height: 8);
      }
      return const SizedBox.shrink();
    }

    // Place cards với animation
    if (index <= places.length) {
      final place = places[index - 1];
      return AnimatedPlaceCard(
        place: place,
        index: index,
        isExpanded: isExpanded,
      );
    }

    // Spacing sau place cards
    if (index == places.length + 1) {
      return const SizedBox(height: 12);
    }

    // Add button
    if (index == places.length + 2) {
      return const AddPlaceButton();
    }

    // Bottom spacing
    return const SizedBox(height: 8);
  }
}
