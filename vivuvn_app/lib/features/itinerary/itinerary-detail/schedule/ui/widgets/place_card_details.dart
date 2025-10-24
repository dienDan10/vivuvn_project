import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/location.dart';
import 'place_action_buttons_section.dart';
import 'place_card_note.dart';
import 'place_info_section.dart';
import 'place_photos_section.dart';

class PlaceCardDetails extends ConsumerStatefulWidget {
  const PlaceCardDetails({super.key, required this.location});

  final Location location;

  @override
  ConsumerState<PlaceCardDetails> createState() => _PlaceCardDetailsState();
}

class _PlaceCardDetailsState extends ConsumerState<PlaceCardDetails> {
  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlaceCardNote(location: widget.location),
          const SizedBox(height: 8),
          PlaceInfoSection(location: widget.location),
          if (widget.location.photos.length > 1) ...[
            const SizedBox(height: 12),
            PlacePhotosSection(
              photos: widget.location.photos,
              locationId: widget.location.id,
            ),
          ],
          const SizedBox(height: 16),
          PlaceActionButtonsSection(location: widget.location),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
