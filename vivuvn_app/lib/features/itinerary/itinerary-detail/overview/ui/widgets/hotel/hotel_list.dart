import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/hotels_controller.dart';
import '../../../controller/list_expand_controller.dart';
import '../../../data/dto/hotel_item_response.dart';
import '../../../state/list_expand_state.dart';
import 'add_hotel_button.dart';
import 'animated_hotel_card.dart';
import 'hotel_list_header.dart';

class HotelList extends ConsumerStatefulWidget {
  const HotelList({super.key});

  @override
  ConsumerState<HotelList> createState() => _HotelListState();
}

class _HotelListState extends ConsumerState<HotelList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final hotelsState = ref.watch(hotelsControllerProvider);
    final List<HotelItemResponse> hotels = hotelsState.hotels;

    final expandState = ref.watch(hotelListExpandControllerProvider);
    final isExpanded = expandState.isExpanded;

    // Sync animation with expand state
    ref.listen<ListExpandState>(
      hotelListExpandControllerProvider,
      (final previous, final next) {
        if (next.isExpanded) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        HotelListHeader(
          hotelsCount: hotels.length,
          isExpanded: isExpanded,
          iconRotationAnimation: _iconRotationAnimation,
          onToggle: () {
            ref.read(hotelListExpandControllerProvider.notifier).toggle();
          },
        ),

        // If collapsed show small spacing
        if (!isExpanded) const SizedBox(height: 8),

        // Hotel cards
        if (isExpanded)
          for (var i = 0; i < hotels.length; i++)
            AnimatedHotelCard(
              hotel: hotels[i],
              index: i + 1,
              isExpanded: isExpanded,
            ),

        // Spacing after hotel cards
        if (isExpanded) const SizedBox(height: 8),

        // Add button
        if (isExpanded) const AddHotelButton(),

        // Bottom spacing
        const SizedBox(height: 8),
      ],
    );
  }
}
