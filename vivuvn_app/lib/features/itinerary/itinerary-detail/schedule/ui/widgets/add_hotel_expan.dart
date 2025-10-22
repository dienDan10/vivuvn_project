import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_place_bottom_sheet.dart';
import 'add_place_button.dart';

class AddHotelTile extends ConsumerWidget {
  final int dayId;

  const AddHotelTile({super.key, required this.dayId});

  void _openAddHotelSheet(final BuildContext context, final WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(type: 'hotel', dayId: dayId),
      ),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ExpansionTile(
      title: const Text('Thêm khách sạn / nhà nghỉ'),
      childrenPadding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        AddPlaceButton(
          dayId: dayId,
          label: 'Thêm nơi lưu trú',
          onPressed: () => _openAddHotelSheet(context, ref),
        ),
      ],
    );
  }
}
