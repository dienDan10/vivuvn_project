import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/hotels_controller.dart';

class HotelDeleteButton extends ConsumerWidget {
  const HotelDeleteButton({
    required this.hotelId,
    required this.hotelName,
    super.key,
  });

  final String hotelId;
  final String hotelName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc chắn muốn xóa "$hotelName" khỏi danh sách?',
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
              .read(hotelsControllerProvider.notifier)
              .removeHotel(hotelId);
          if (context.mounted) {
            GlobalToast.showSuccessToast(
              context,
              message: 'Xóa khách sạn thành công',
            );
          }
        }
      },
      icon: const Icon(Icons.delete),
    );
  }
}
