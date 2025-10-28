import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/hotels_restaurants_controller.dart';
import 'edit_restaurant_modal.dart';
import 'restaurant_card.dart';

class SlidableRestaurantCard extends ConsumerWidget {
  const SlidableRestaurantCard({
    required this.restaurant,
    this.index,
    super.key,
  });

  final RestaurantItem restaurant;
  final int? index;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return RepaintBoundary(
      child: Slidable(
        key: ValueKey(restaurant.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.36,
          children: [
            SlidableAction(
              onPressed: (final context) => _handleEdit(context, ref),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Sửa',
            ),
            SlidableAction(
              onPressed: (final context) => _handleDelete(context, ref),
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

  Future<void> _handleEdit(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    await showEditRestaurantModal(context, restaurantToEdit: restaurant);

    // Giả lập API call thành công
    if (context.mounted) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Cập nhật thông tin nhà hàng thành công',
      );
    }
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
      ref
          .read(hotelsRestaurantsControllerProvider.notifier)
          .removeRestaurant(restaurant.id);
    }
  }
}
