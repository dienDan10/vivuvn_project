import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../detail/controller/itinerary_detail_controller.dart';
import '../../../controller/favourite_places_controller.dart';
import 'place_card.dart';

class SlidablePlaceCard extends ConsumerWidget {
  const SlidablePlaceCard({
    required this.title,
    required this.description,
    required this.locationId,
    this.imageUrl,
    this.index,
    this.placeUri,
    this.directionsUri,
    this.locationQuery,
    super.key,
  });

  final String title;
  final String description;
  final int locationId;
  final String? imageUrl;
  final int? index;
  final String? placeUri;
  final String? directionsUri;
  final String? locationQuery;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isOwner = ref.watch(
      itineraryDetailControllerProvider.select(
        (final s) => s.itinerary?.isOwner ?? false,
      ),
    );

    final placeCard = PlaceCard(
      title: title,
      description: description,
      imageUrl: imageUrl,
      index: index,
      placeUri: placeUri,
      directionsUri: directionsUri,
      locationQuery: locationQuery,
    );

    if (!isOwner) {
      return RepaintBoundary(child: placeCard);
    }

    return RepaintBoundary(
      child: Slidable(
        key: ValueKey(locationId),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.18,
          children: [
            SlidableAction(
              onPressed: (final context) => _handleDelete(context, ref),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
            ),
          ],
        ),
        child: placeCard,
      ),
    );
  }

  Future<void> _handleDelete(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final placeName = title;

    // Hiện dialog xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa "$placeName" khỏi danh sách yêu thích?',
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

    // Nếu user xác nhận, gọi API delete
    if (confirmed == true) {
      await ref
          .read(favouritePlacesControllerProvider.notifier)
          .deletePlaceFromWishlist(locationId);
    }
  }
}
