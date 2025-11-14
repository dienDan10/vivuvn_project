import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../detail/controller/itinerary_detail_controller.dart';
import 'add_restaurant_modal.dart';

class AddRestaurantButton extends ConsumerWidget {
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
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.itinerary?.isOwner ?? false,
      ),
    );

    if (!isOwner) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _showAddRestaurantModal(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              'Thêm nhà hàng',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
