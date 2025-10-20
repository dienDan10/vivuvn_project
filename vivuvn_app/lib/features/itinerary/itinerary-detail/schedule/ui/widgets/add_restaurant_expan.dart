import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/itinerary_detail_controller.dart';
import 'add_place_bottom_sheet.dart';
import 'add_place_button.dart';

class AddRestaurantTile extends ConsumerWidget {
  final int dayId;

  const AddRestaurantTile({super.key, required this.dayId});

  void _openAddRestaurantSheet(
    final BuildContext context,
    final WidgetRef ref,
  ) {
    final itineraryId = ref.read(itineraryDetailControllerProvider).itineraryId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(
          type: 'restaurant',
          dayId: dayId,
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ExpansionTile(
      title: const Text('Thêm nhà hàng / quán ăn'),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        AddPlaceButton(
          dayId: dayId,
          label: 'Thêm địa điểm ăn uống',
          onPressed: () => _openAddRestaurantSheet(context, ref),
        ),
      ],
    );
  }
}
