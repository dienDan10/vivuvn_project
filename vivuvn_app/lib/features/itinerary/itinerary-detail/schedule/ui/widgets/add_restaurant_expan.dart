import 'package:flutter/material.dart';

import 'add_place_bottom_sheet.dart';
import 'add_place_button.dart';

class AddRestaurantTile extends StatelessWidget {
  const AddRestaurantTile({super.key});

  void _openAddRestaurantSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final context) => const FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(type: 'restaurant'),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return ExpansionTile(
      title: const Text('Thêm nhà hàng / quán ăn'),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        SizedBox(
          width: double.infinity,
          child: AddPlaceButton(
            label: 'Thêm địa điểm ăn uống',
            onPressed: () => _openAddRestaurantSheet(context),
          ),
        ),
      ],
    );
  }
}
