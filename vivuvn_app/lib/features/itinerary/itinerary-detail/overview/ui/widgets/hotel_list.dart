import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/hotels_restaurants_controller.dart';
import 'hotel_list_item.dart';

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
    final hotelsState = ref.watch(hotelsRestaurantsControllerProvider);
    final hotels = hotelsState.hotels;

    // Calculate total items: header(1) + hotels(n) + spacing(1) + button(1) + bottom(1)
    const extraItemsCount = 4;
    final totalItemCount = hotels.length + extraItemsCount;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalItemCount,
      itemBuilder: (final context, final index) => HotelListItem(
        index: index,
        hotels: hotels,
        isExpanded: _isExpanded,
        iconRotationAnimation: _iconRotationAnimation,
        onToggle: toggleExpanded,
      ),
    );
  }
}
