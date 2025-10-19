import 'package:flutter/material.dart';

class PlacePhotosSection extends StatelessWidget {
  const PlacePhotosSection({super.key, required this.photos});

  final List<String> photos;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, final __) => const SizedBox(width: 8),
        itemBuilder: (_, final i) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            photos[i],
            width: 100,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
