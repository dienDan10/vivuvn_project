import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/restaurants_controller.dart';
import '../../data/dto/restaurant_item_response.dart';
import 'add_restaurant_button.dart';
import 'animated_restaurant_card.dart';
import 'restaurant_list_header.dart';

class RestaurantList extends ConsumerStatefulWidget {
  const RestaurantList({super.key});

  @override
  ConsumerState<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends ConsumerState<RestaurantList>
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
    final restaurantsState = ref.watch(restaurantsControllerProvider);
    final List<RestaurantItemResponse> restaurants =
        restaurantsState.restaurants;
    // Render section similarly to HotelList (header, collapse/expand,
    // animated restaurant cards, add button and spacing).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RestaurantListHeader(
          restaurantsCount: restaurants.length,
          isExpanded: _isExpanded,
          iconRotationAnimation: _iconRotationAnimation,
          onToggle: toggleExpanded,
        ),

        if (!_isExpanded) const SizedBox(height: 8),

        if (_isExpanded)
          for (var i = 0; i < restaurants.length; i++)
            AnimatedRestaurantCard(
              restaurant: restaurants[i],
              index: i + 1,
              isExpanded: _isExpanded,
            ),

        if (_isExpanded) const SizedBox(height: 8),

        if (_isExpanded) const AddRestaurantButton(),

        const SizedBox(height: 8),
      ],
    );
  }
}
