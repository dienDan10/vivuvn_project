import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/restaurants_controller.dart';

class RestaurantDeleteButton extends ConsumerWidget {
  const RestaurantDeleteButton({
    required this.restaurantId,
    required this.restaurantName,
    super.key,
  });

  final String restaurantId;
  final String restaurantName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc chắn muốn xóa "$restaurantName" khỏi danh sách?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Xóa'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await ref
              .read(restaurantsControllerProvider.notifier)
              .removeRestaurant(restaurantId);
          if (context.mounted) {
            GlobalToast.showSuccessToast(
              context,
              message: 'Xóa nhà hàng thành công',
            );
          }
        }
      },
      icon: const Icon(Icons.delete),
    );
  }
}
