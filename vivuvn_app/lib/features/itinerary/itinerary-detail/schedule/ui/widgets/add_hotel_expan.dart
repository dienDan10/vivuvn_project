import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_place_bottom_sheet.dart';
import 'add_place_button.dart';

class AddHotelTile extends ConsumerWidget {
  const AddHotelTile({super.key});

  void _openAddHotelSheet(final BuildContext context, final WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(type: 'hotel'),
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
          label: 'Thêm nơi lưu trú',
          onPressed: () => _openAddHotelSheet(context, ref),
        ),
      ],
    );
  }
}
