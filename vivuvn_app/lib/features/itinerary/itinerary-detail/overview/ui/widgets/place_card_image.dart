import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaceCardImage extends StatelessWidget {
  const PlaceCardImage({required this.imageUrl, this.size = 80, super.key});

  final String? imageUrl;
  final double size;

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder(colorScheme);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        progressIndicatorBuilder:
            (final context, final url, final downloadProgress) => Container(
              width: size,
              height: size,
              color: colorScheme.primaryContainer,
              child: Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  strokeWidth: 2,
                ),
              ),
            ),
        errorWidget: (final context, final url, final error) {
          return _buildPlaceholder(colorScheme);
        },
        // Lazy loading configuration
        memCacheWidth: (size * 2).toInt(),
        memCacheHeight: (size * 2).toInt(),
        maxWidthDiskCache: (size * 3).toInt(),
        maxHeightDiskCache: (size * 3).toInt(),
      ),
    );
  }

  /// Placeholder khi không có ảnh hoặc ảnh lỗi
  Widget _buildPlaceholder(final ColorScheme colorScheme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image,
        color: colorScheme.onPrimaryContainer,
        size: size * 0.45,
      ),
    );
  }
}
