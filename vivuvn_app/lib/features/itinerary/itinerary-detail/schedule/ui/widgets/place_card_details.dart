import 'package:flutter/material.dart';

import '../../model/location.dart';
import 'place_description_section.dart';
import 'place_info_row.dart';
import 'place_link_row.dart';
import 'place_photos_section.dart';

class PlaceCardDetails extends StatelessWidget {
  const PlaceCardDetails({super.key, required this.location});

  final Location location;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Mô tả
        if (location.description.isNotEmpty)
          PlaceDescriptionSection(description: location.description),

        // 🔹 Thông tin khác
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
            text: '${location.rating} (${location.ratingCount ?? 0} đánh giá)',
          ),
        if (location.websiteUri != null && location.websiteUri!.isNotEmpty)
          PlaceLinkRow(url: location.websiteUri!),

        const SizedBox(height: 8),

        // 🔹 Ảnh bổ sung
        if (location.photos.length > 1)
          PlacePhotosSection(photos: location.photos),
      ],
    );
  }
}
