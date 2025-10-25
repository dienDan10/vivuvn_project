import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_place_bottom_sheet.dart';
import 'add_place_button.dart';

class AddRestaurantTile extends ConsumerWidget {
  const AddRestaurantTile({super.key});

  void _openAddRestaurantSheet(
    final BuildContext context,
    final WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.8,
        child: AddPlaceBottomSheet(type: 'restaurant'),
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
          label: 'Thêm địa điểm ăn uống',
          onPressed: () => _openAddRestaurantSheet(context, ref),
        ),
      ],
    );
  }
}
