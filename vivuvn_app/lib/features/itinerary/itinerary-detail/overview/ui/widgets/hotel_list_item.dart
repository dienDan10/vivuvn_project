import 'package:flutter/material.dart';

import '../../data/dto/hotel_item_response.dart';
import 'add_hotel_button.dart';
import 'animated_hotel_card.dart';
import 'hotel_list_header.dart';

class HotelListItem extends StatelessWidget {
  const HotelListItem({
    required this.index,
    required this.hotels,
    required this.isExpanded,
    required this.iconRotationAnimation,
    required this.onToggle,
    super.key,
  });

  final int index;
  final List<HotelItemResponse> hotels;
  final bool isExpanded;
  final Animation<double> iconRotationAnimation;
  final VoidCallback onToggle;

  @override
  Widget build(final BuildContext context) {
    // Header với toggle button
    if (index == 0) {
      return HotelListHeader(
        hotelsCount: hotels.length,
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

    // Hotel cards với animation
    if (index <= hotels.length) {
      final hotel = hotels[index - 1];
      return AnimatedHotelCard(
        hotel: hotel,
        index: index,
        isExpanded: isExpanded,
      );
    }

    // Spacing sau hotel cards
    if (index == hotels.length + 1) {
      return const SizedBox(height: 8);
    }

    // Add button
    if (index == hotels.length + 2) {
      return const AddHotelButton();
    }

    // Bottom spacing
    return const SizedBox(height: 8);
  }
}
