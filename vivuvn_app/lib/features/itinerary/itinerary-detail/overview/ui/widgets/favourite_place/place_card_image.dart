import 'package:flutter/material.dart';

class PlaceCardImage extends StatelessWidget {
  const PlaceCardImage({required this.imageUrl, this.size = 80, super.key});

  final String? imageUrl;
  final double size;

  static const String _placeholderPath = 'assets/images/image-placeholder.jpeg';

  @override
  Widget build(final BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholderImage();
    }

    return FadeInImage.assetNetwork(
      placeholder: _placeholderPath,
      image: imageUrl!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      imageErrorBuilder: (final context, final error, final stackTrace) {
        return _buildPlaceholderImage();
      },
    );
  }

  Widget _buildPlaceholderImage() {
    return Image.asset(
      _placeholderPath,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
