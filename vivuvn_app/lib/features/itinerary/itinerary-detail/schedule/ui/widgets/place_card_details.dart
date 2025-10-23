import 'package:flutter/material.dart';

import '../../model/location.dart';
import 'place_action_button_direction.dart';
import 'place_action_button_info.dart';
import 'place_action_button_location.dart';
import 'place_action_button_website.dart';
import 'place_info_row.dart';
import 'place_photos_section.dart';

class PlaceCardDetails extends StatelessWidget {
  const PlaceCardDetails({super.key, required this.location});

  final Location location;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (location.address.isNotEmpty)
            PlaceInfoRow(
              icon: Icons.location_on_outlined,
              text: location.address,
            ),
          if (location.provinceName.isNotEmpty)
            PlaceInfoRow(icon: Icons.map_outlined, text: location.provinceName),
          if (location.rating > 0)
            PlaceInfoRow(
              icon: Icons.star_rate_rounded,
              text:
                  '${location.rating} (${location.ratingCount ?? 0} đánh giá)',
            ),

          const SizedBox(height: 12),

          if (location.photos.length > 1)
            PlacePhotosSection(
              photos: location.photos,
              locationId: location.id,
            ),

          const SizedBox(height: 16),

          // ==== Các nút hành động ====
          SizedBox(
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
          ),
        ],
      ),
    );
  }
}
