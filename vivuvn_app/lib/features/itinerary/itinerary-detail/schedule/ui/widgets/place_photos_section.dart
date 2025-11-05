import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../overview/ui/widgets/favourite_place/place_card_image.dart';

class PlacePhotosSection extends StatelessWidget {
  const PlacePhotosSection({
    super.key,
    required this.photos,
    required this.locationId,
  });

  final List<String> photos;
  final int locationId;

  void _openImageGallery(final BuildContext context, final int initialIndex) {
    showDialog(
      context: context,
      barrierDismissible: true, // ấn ra ngoài để thoát
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context), // tap ra vùng ngoài để thoát
          child: Stack(
            children: [
              // Nền đen mờ
              Container(color: Colors.black.withValues(alpha: 0.95)),

              // PageView ảnh (vuốt trái/phải)
              Center(
                child: PageView.builder(
                  controller: PageController(initialPage: initialIndex),
                  itemCount: photos.length,
                  itemBuilder: (final context, final index) {
                    final photoUrl = photos[index];
                    return Hero(
                      tag: 'photo_${locationId}_$index',
                      child: InteractiveViewer(
                        clipBehavior: Clip.none,
                        panEnabled: true,
                        minScale: 0.8,
                        maxScale: 4.0, // độ zoom tối đa
                        child: CachedNetworkImage(
                          imageUrl: photoUrl,
                          fit: BoxFit.contain,
                          errorWidget: (_, final __, final ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Nút đóng
              Positioned(
                top: 20,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    if (photos.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text('Không có hình ảnh')),
      );
    }

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, final __) => const SizedBox(width: 8),
        itemBuilder: (final context, final index) => GestureDetector(
          onTap: () => _openImageGallery(context, index),
          child: Hero(
            tag: 'photo_${locationId}_$index',
            child: PlaceCardImage(imageUrl: photos[index], size: 80),
          ),
        ),
      ),
    );
  }
}
