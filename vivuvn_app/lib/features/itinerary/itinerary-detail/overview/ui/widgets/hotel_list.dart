import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/hotels_controller.dart';
import '../../data/dto/hotel_item_response.dart';
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
  bool _isExpanded = false;
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

  void toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final hotelsState = ref.watch(hotelsControllerProvider);
    final List<HotelItemResponse> hotels = hotelsState.hotels;

    // Render section similarly to PlaceListItem (single column) — header,
    // collapse/expand, animated hotel cards, add button and spacing.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        HotelListHeader(
          hotelsCount: hotels.length,
          isExpanded: _isExpanded,
          iconRotationAnimation: _iconRotationAnimation,
          onToggle: toggleExpanded,
        ),

        // If collapsed show small spacing
        if (!_isExpanded) const SizedBox(height: 8),

        // Hotel cards
        if (_isExpanded)
          for (var i = 0; i < hotels.length; i++)
            AnimatedHotelCard(
              hotel: hotels[i],
              index: i + 1,
              isExpanded: _isExpanded,
            ),

        // Spacing after hotel cards
        if (_isExpanded) const SizedBox(height: 8),

        // Add button
        if (_isExpanded) const AddHotelButton(),

        // Bottom spacing
        const SizedBox(height: 8),
      ],
    );
  }
}
