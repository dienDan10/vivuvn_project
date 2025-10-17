import 'package:flutter/material.dart';

import '../data/dto/favourite_places_response.dart';
import 'widgets/add_place_button.dart';
import 'widgets/animated_place_card.dart';
import 'widgets/place_list_header.dart';

/// Main widget hiển thị danh sách địa điểm yêu thích
/// Hỗ trợ expand/collapse với animation
class PlaceList extends StatefulWidget {
  const PlaceList({super.key});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isExpanded = false; // ← Trạng thái đóng/mở (mặc định đóng)
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;

  @override
  bool get wantKeepAlive => true; // ← Giữ state khi switch tabs

  // Sử dụng fake data từ FavouritePlacesResponse
  final List<FavouritePlacesResponse> _places =
      FavouritePlacesResponse.fakeData();

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
    super.build(context); // ← Gọi super.build để AutomaticKeepAlive hoạt động

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (final context, final index) => _buildItem(context, index),
        childCount:
            _places.length + 4, // header + places + spacing + button + bottom
      ),
    );
  }

  /// Build từng item trong list dựa trên index
  Widget _buildItem(final BuildContext context, final int index) {
    // Header với toggle button
    if (index == 0) {
      return PlaceListHeader(
        placesCount: _places.length,
        isExpanded: _isExpanded,
        iconRotationAnimation: _iconRotationAnimation,
        onToggle: _toggleExpanded,
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
      return AnimatedPlaceCard(
        place: place,
        index: index,
        isExpanded: _isExpanded,
      );
    }

    // Spacing sau place cards
    if (index == _places.length + 1) {
      return const SizedBox(height: 12);
    }

    // Add button
    if (index == _places.length + 2) {
      return const AddPlaceButton();
    }

    // Bottom spacing
    return const SizedBox(height: 80);
  }
}
