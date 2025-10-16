import 'package:flutter/material.dart';

import 'add_place_modal.dart';
import 'slidable_place_card.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({super.key});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true; // ← Trạng thái đóng/mở
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;

  // Static list data để tránh recreate
  static const _places = [
    {
      'title': 'Bãi biển Mỹ Khê',
      'description':
          'Bãi biển Mỹ Khê là một bãi biển đẹp, nằm trên trục chính từ Bắc vào Nam. Nước biển trong xanh, sóng đánh hiền hòa, cát trắng mịn...',
    },
    {
      'title': 'Cầu Rồng',
      'description':
          'Cầu Rồng là biểu tượng nổi tiếng của Đà Nẵng, phun lửa và nước vào cuối tuần...',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotationAnimation =
        Tween<double>(
          begin: 0.0,
          end: 0.5, // 180 degrees (0.5 * 2 * pi)
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Start expanded
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    // Sử dụng SliverChildBuilderDelegate thay vì SliverChildListDelegate
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (final context, final index) {
          // Header với nút toggle
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Địa điểm yêu thích (${_places.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RotationTransition(
                    turns: _iconRotationAnimation,
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onPressed: _toggleExpanded,
                      tooltip: _isExpanded ? 'Thu gọn' : 'Mở rộng',
                    ),
                  ),
                ],
              ),
            );
          }

          // Nếu đang thu gọn, chỉ hiển thị bottom spacing
          if (!_isExpanded) {
            if (index == 1) {
              return const SizedBox(height: 12);
            }
            return const SizedBox.shrink();
          }

          // Place cards với animation
          if (index <= _places.length) {
            final place = _places[index - 1];
            return AnimatedOpacity(
              opacity: _isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedSlide(
                offset: _isExpanded ? Offset.zero : const Offset(0, -0.2),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SlidablePlaceCard(
                  key: ValueKey(place['title']),
                  title: place['title']!,
                  description: place['description']!,
                  index: index, // ← Pass số thứ tự (1-based index)
                ),
              ),
            );
          }

          // Spacing
          if (index == _places.length + 1) {
            return const SizedBox(height: 12);
          }

          // Add button
          if (index == _places.length + 2) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (final context) => const AddPlaceModal(),
                    );
                  },
                  icon: const Icon(Icons.add_location_alt_outlined, size: 20),
                  label: const Text('Thêm địa điểm yêu thích'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          }

          // Bottom spacing
          return const SizedBox(height: 80);
        },
        childCount:
            _places.length + 4, // header + places + spacing + button + bottom
      ),
    );
  }
}
