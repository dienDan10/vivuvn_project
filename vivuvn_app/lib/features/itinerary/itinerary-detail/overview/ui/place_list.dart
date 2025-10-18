import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/favourite_places_controller.dart';
import 'widgets/place_list_item.dart';

class PlaceList extends ConsumerStatefulWidget {
  const PlaceList({required this.itineraryId, super.key});

  final int itineraryId;

  @override
  ConsumerState<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends ConsumerState<PlaceList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isExpanded = false; // ← Trạng thái đóng/mở (mặc định đóng)
  late AnimationController _animationController;
  late Animation<double> _iconRotationAnimation;

  @override
  bool get wantKeepAlive => true; // ← Giữ state khi switch tabs

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

    // Load favourite places khi widget được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(favouritePlacesControllerProvider.notifier)
          .loadFavouritePlaces(widget.itineraryId);
    });
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

    // Lấy danh sách places từ controller
    final favouritePlacesState = ref.watch(favouritePlacesControllerProvider);
    final places = favouritePlacesState.places;

    // Hiển thị loading nếu đang tải lần đầu
    if (favouritePlacesState.isLoading && places.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Hiển thị error nếu có
    if (favouritePlacesState.error != null && places.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                favouritePlacesState.error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Calculate total items: header(1) + places(n) + spacing(1) + button(1) + bottom(1)
    const extraItemsCount = 4;
    final totalItemCount = places.length + extraItemsCount;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (final context, final index) => PlaceListItem(
          index: index,
          places: places,
          isExpanded: _isExpanded,
          iconRotationAnimation: _iconRotationAnimation,
          onToggle: _toggleExpanded,
          itineraryId: widget.itineraryId,
        ),
        childCount: totalItemCount,
      ),
    );
  }
}
