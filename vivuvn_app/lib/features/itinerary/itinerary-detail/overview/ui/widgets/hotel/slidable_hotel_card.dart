import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../controller/hotels_controller.dart';
import '../../../data/dto/hotel_item_response.dart';
import 'hotel_card.dart';

class SlidableHotelCard extends ConsumerWidget {
  const SlidableHotelCard({required this.hotel, this.index, super.key});

  final HotelItemResponse hotel;
  final int? index;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return RepaintBoundary(
      child: Slidable(
        key: ValueKey(hotel.id),
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
        child: HotelCard(hotel: hotel, index: index),
      ),
    );
  }

  Future<void> _handleDelete(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final hotelName = hotel.name;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa "$hotelName" khỏi danh sách?'),
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
      await ref.read(hotelsControllerProvider.notifier).removeHotel(hotel.id);
    }
  }
}
