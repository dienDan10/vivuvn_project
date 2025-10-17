import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'place_card.dart';

class SlidablePlaceCard extends StatelessWidget {
  const SlidablePlaceCard({
    required this.title,
    required this.description,
    this.imageUrl,
    this.index,
    this.onDelete,
    this.onShare,
    super.key,
  });

  final String title;
  final String description;
  final String? imageUrl;
  final int? index;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  @override
  Widget build(final BuildContext context) {
    return RepaintBoundary(
      child: Slidable(
        key: ValueKey(title),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.18,
          children: [
            SlidableAction(
              onPressed: (final context) => _handleDelete(context),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
            ),
          ],
        ),
        child: PlaceCard(
          title: title,
          description: description,
          imageUrl: imageUrl,
          index: index,
        ),
      ),
    );
  }

  void _handleDelete(final BuildContext context) {
    // Gọi callback nếu có
    onDelete?.call();

    // Hiển thị SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "$title"'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            // TODO: Implement undo logic
          },
        ),
      ),
    );
  }
}
