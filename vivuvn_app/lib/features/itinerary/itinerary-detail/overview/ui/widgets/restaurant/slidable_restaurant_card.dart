import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../controller/restaurants_controller.dart';
import '../../../data/dto/restaurant_item_response.dart';
import 'restaurant_card.dart';

class SlidableRestaurantCard extends ConsumerWidget {
  const SlidableRestaurantCard({
    required this.restaurant,
    this.index,
    super.key,
  });

  final RestaurantItemResponse restaurant;
  final int? index;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return RepaintBoundary(
      child: Slidable(
        key: ValueKey(restaurant.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.22,
          children: [
            SlidableAction(
              onPressed: (final _) => _handleDelete(context, ref),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
            ),
          ],
        ),
        child: RestaurantCard(restaurant: restaurant, index: index),
      ),
    );
  }

  Future<void> _handleDelete(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa "${restaurant.name}" khỏi danh sách?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(restaurantsControllerProvider.notifier)
          .removeRestaurant(restaurant.id);
    }
  }
}
