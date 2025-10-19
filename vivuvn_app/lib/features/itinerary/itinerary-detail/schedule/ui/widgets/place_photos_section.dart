import 'package:flutter/material.dart';

import '../../../overview/ui/widgets/place_card_image.dart';

class PlacePhotosSection extends StatelessWidget {
  const PlacePhotosSection({super.key, required this.photos});

  final List<String> photos;

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
        itemBuilder: (_, final i) => PlaceCardImage(
          imageUrl: photos[i],
          size: 80,
        ),
      ),
    );
  }
}
