import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoGalleryDialog extends StatelessWidget {
  final List<String> photos;
  final int initialIndex;
  final int locationId;

  const PhotoGalleryDialog({
    super.key,
    required this.photos,
    required this.initialIndex,
    required this.locationId,
  });

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.95)),
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
                    maxScale: 4.0,
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
  }
}
