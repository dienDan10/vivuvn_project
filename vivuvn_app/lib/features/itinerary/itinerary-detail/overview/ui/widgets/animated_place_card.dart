import 'package:flutter/material.dart';

import '../../data/dto/favourite_places_response.dart';
import 'slidable_place_card.dart';

class AnimatedPlaceCard extends StatelessWidget {
  const AnimatedPlaceCard({
    required this.place,
    required this.index,
    required this.isExpanded,
    required this.itineraryId,
    super.key,
  });

  final FavouritePlacesResponse place;
  final int index;
  final bool isExpanded;
  final int itineraryId;

  @override
  Widget build(final BuildContext context) {
    return AnimatedOpacity(
      opacity: isExpanded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedSlide(
        offset: isExpanded ? Offset.zero : const Offset(0, -0.2),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: SlidablePlaceCard(
          key: ValueKey(place.idInWishlist),
          title: place.name,
          description: place.description,
          imageUrl: place.imageUrl,
          index: index,
          itineraryId: itineraryId,
          locationId: place.locationId,
        ),
      ),
    );
  }
}
