import 'package:flutter/material.dart';

import 'add_place_bottom_sheet.dart';
import 'add_place_button.dart';

class AddHotelTile extends StatelessWidget {
  const AddHotelTile({super.key});

  void _openAddHotelSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final context) => const FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(type: 'hotel'),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return ExpansionTile(
      title: const Text('Thêm khách sạn / nhà nghỉ'),
      childrenPadding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        AddPlaceButton(
          label: 'Thêm nơi lưu trú',
          onPressed: () => _openAddHotelSheet(context),
        ),
      ],
    );
  }
}
