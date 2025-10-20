import 'package:flutter/material.dart';

import '../../../overview/ui/widgets/place_card_image.dart';
import '../../model/location.dart';

class PlaceCardHeader extends StatelessWidget {
  const PlaceCardHeader({super.key, required this.location});

  final Location location;

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlaceCardImage(
          imageUrl: location.photos.isNotEmpty ? location.photos.first : null,
          size: 80,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            location.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
