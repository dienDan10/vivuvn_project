import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/hotels_controller.dart';
import 'add_hotel_button.dart';
import 'animated_hotel_card.dart';
import 'hotel_list_header.dart';

class HotelListItem extends ConsumerWidget {
  const HotelListItem({
    required this.index,
    required this.isExpanded,
    required this.iconRotationAnimation,
    required this.onToggle,
    super.key,
  });

  final int index;
  final bool isExpanded;
  final Animation<double> iconRotationAnimation;
  final VoidCallback onToggle;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final hotels = ref.watch(
      hotelsControllerProvider.select((final s) => s.hotels),
    );

    // Header
    if (index == 0) {
      return HotelListHeader(
        hotelsCount: hotels.length,
        isExpanded: isExpanded,
        iconRotationAnimation: iconRotationAnimation,
        onToggle: onToggle,
      );
    }

    // Collapsed spacing
    if (!isExpanded) {
      if (index == 1) {
        return const SizedBox(height: 8);
      }
      return const SizedBox.shrink();
    }

    // Hotel cards
    if (index <= hotels.length) {
      final hotel = hotels[index - 1];
      return AnimatedHotelCard(
        hotel: hotel,
        index: index,
        isExpanded: isExpanded,
      );
    }

    // Spacing after cards
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
