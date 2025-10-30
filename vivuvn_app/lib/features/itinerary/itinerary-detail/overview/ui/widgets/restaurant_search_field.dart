import 'package:flutter/material.dart';

import '../../modal/location.dart';

class RestaurantSearchField extends StatelessWidget {
  final Location? selectedLocation;
  final VoidCallback onTap;

  const RestaurantSearchField({
    super.key,
    required this.selectedLocation,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedLocation?.name ?? 'Tìm kiếm nhà hàng',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedLocation != null
                      ? Colors.black
                      : Colors.grey[400],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
