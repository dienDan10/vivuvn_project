import 'package:flutter/material.dart';

class HotelListHeader extends StatelessWidget {
  const HotelListHeader({
    required this.hotelsCount,
    required this.isExpanded,
    required this.iconRotationAnimation,
    required this.onToggle,
    super.key,
  });

  final int hotelsCount;
  final bool isExpanded;
  final Animation<double> iconRotationAnimation;
  final VoidCallback onToggle;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Khách sạn ($hotelsCount)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RotationTransition(
              turns: iconRotationAnimation,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
