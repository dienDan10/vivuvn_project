import 'package:flutter/material.dart';

class SliverActionsBar extends StatelessWidget {
  const SliverActionsBar({super.key});

  @override
  Widget build(final BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: _SliverActionsBarDelegate(),
    );
  }
}

class _SliverActionsBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 56; // Chiều cao tối thiểu
  @override
  double get maxExtent => 56; // Chiều cao tối đa

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    // Dùng Material để đảm bảo header có layout đúng
    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: Colors.white,
      child: Container(
        height: maxExtent,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Tổng quan', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Lịch trình'),
            Text('Ngân sách'),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant final _SliverActionsBarDelegate oldDelegate) =>
      false;
}
