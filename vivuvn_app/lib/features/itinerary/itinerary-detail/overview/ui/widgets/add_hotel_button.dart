import 'package:flutter/material.dart';

import 'add_hotel_modal.dart';

class AddHotelButton extends StatelessWidget {
  const AddHotelButton({super.key});

  void _showAddHotelModal(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => const AddHotelModal(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: OutlinedButton(
        onPressed: () => _showAddHotelModal(context),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Thêm khách sạn', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
