import 'package:flutter/material.dart';

import '../../model/location.dart';
import 'place_info_row.dart';

class PlaceInfoSection extends StatelessWidget {
  const PlaceInfoSection({super.key, required this.location});

  final Location location;

  @override
  Widget build(final BuildContext context) {
    return Column(
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
            text: '${location.rating} (${location.ratingCount ?? 0} đánh giá)',
          ),
      ],
    );
  }
}
