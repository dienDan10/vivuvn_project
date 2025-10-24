import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'photo_gallery_dialog.dart';

class LocationPhotosTab extends StatelessWidget {
  final dynamic location;
  const LocationPhotosTab({super.key, required this.location});

  void _openImageGallery(
    final BuildContext context,
    final List<String> photos,
    final int index,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PhotoGalleryDialog(
        photos: photos,
        initialIndex: index,
        locationId: location.id,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final photos = location.photos;
    if (photos.isEmpty) {
      return const Center(child: Text('Không có hình ảnh bổ sung'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: photos.length,
      itemBuilder: (final context, final index) {
        final photoUrl = photos[index];
        return GestureDetector(
          onTap: () => _openImageGallery(context, photos, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              fit: BoxFit.cover,
              placeholder: (_, final __) => Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, final __, final ___) =>
                  const Icon(Icons.broken_image, size: 40),
            ),
          ),
        );
      },
    );
  }
}
