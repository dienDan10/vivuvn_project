import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'place_card.dart';

class SlidablePlaceCard extends StatelessWidget {
  final String title;
  final String description;
  final int? index; // ← Thêm index
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const SlidablePlaceCard({
    super.key,
    required this.title,
    required this.description,
    this.index,
    this.onDelete,
    this.onShare,
  });

  @override
  Widget build(final BuildContext context) {
    return RepaintBoundary(
      child: Slidable(
        key: ValueKey(title),

        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: [
            SlidableAction(
              onPressed: (final context) {
                _handleDelete(context);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
              // borderRadius: BorderRadius.circular(12),
            ),
            // SlidableAction(
            //   onPressed: (final context) {
            //     _handleShare(context);
            //   },
            //   backgroundColor: Colors.blue,
            //   foregroundColor: Colors.white,
            //   icon: Icons.share,
            //   label: 'Chia sẻ',
            //   // borderRadius: BorderRadius.circular(12),
            // ),
          ],
        ),
        child: PlaceCard(
          title: title,
          description: description,
          index: index, // ← Pass index
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

  void _handleShare(final BuildContext context) {
    // Gọi callback nếu có
    onShare?.call();

    // Hiển thị SnackBar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Chia sẻ "$title"')));
    // TODO: Implement share functionality
  }
}
