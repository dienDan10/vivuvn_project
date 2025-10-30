import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/location.dart';
import 'place_action_button_hotel.dart';
import 'place_action_button_info.dart';
import 'place_action_button_location.dart';
import 'place_action_button_restaurant.dart';
import 'place_card_note.dart';
import 'place_info_section.dart';
import 'place_photos_section.dart';

class PlaceCardDetails extends ConsumerStatefulWidget {
  const PlaceCardDetails({
    super.key,
    required this.dayId,
    required this.itemId,
    required this.location,
  });

  final int dayId;
  final int itemId;
  final Location location;

  @override
  ConsumerState<PlaceCardDetails> createState() => _PlaceCardDetailsState();
}

class _PlaceCardDetailsState extends ConsumerState<PlaceCardDetails> {
  @override
  Widget build(final BuildContext context) {
    final location = widget.location;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///  Ghi chú
          PlaceCardNote(
            dayId: widget.dayId,
            itemId: widget.itemId,
            location: location,
          ),
          const SizedBox(height: 8),

          ///  Thông tin địa điểm
          PlaceInfoSection(location: location),
          if (location.photos.length > 1) ...[
            const SizedBox(height: 12),
            PlacePhotosSection(
              photos: location.photos,
              locationId: location.id,
            ),
          ],
          const SizedBox(height: 16),

          ///  Các nút hành động
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PlaceActionButtonInfo(location: location),
                const SizedBox(width: 8),
                PlaceActionButtonLocation(location: location),
                const SizedBox(width: 8),
                const PlaceActionButtonRestaurant(),
                const SizedBox(width: 8),
                const PlaceActionButtonHotel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
