import 'package:flutter/material.dart';
import 'add_place_bottom_sheet.dart';
import 'add_place_button.dart';

class AddHotelTile extends StatelessWidget {
  final int itineraryId;
  final int dayId;

  const AddHotelTile({
    super.key,
    required this.itineraryId,
    required this.dayId,
  });

  void _openAddHotelSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(
          type: 'hotel',
          itineraryId: itineraryId,
          dayId: dayId,
        ),
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
          itineraryId: itineraryId,
          dayId: dayId,
          label: 'Thêm nơi lưu trú',
          onPressed: () => _openAddHotelSheet(context),
        ),
      ],
    );
  }
}
