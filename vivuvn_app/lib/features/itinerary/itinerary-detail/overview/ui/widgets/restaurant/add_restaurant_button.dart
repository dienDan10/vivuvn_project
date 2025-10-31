import 'package:flutter/material.dart';

import 'add_restaurant_modal.dart';

class AddRestaurantButton extends StatelessWidget {
  const AddRestaurantButton({super.key});

  void _showAddRestaurantModal(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => const AddRestaurantModal(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: OutlinedButton(
        onPressed: () => _showAddRestaurantModal(context),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Thêm nhà hàng', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
