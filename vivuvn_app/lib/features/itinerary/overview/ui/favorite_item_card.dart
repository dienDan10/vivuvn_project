import 'package:flutter/material.dart';

import '../models/favorite_place.dart';

class FavoriteItemCard extends StatelessWidget {
  final FavoritePlace place;
  final VoidCallback? onTap;

  const FavoriteItemCard({super.key, required this.place, this.onTap});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Ảnh địa điểm
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/image-placeholder.jpeg',
                image: place.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                imageErrorBuilder:
                    (final context, final error, final stackTrace) => Container(
                      color: Colors.blueAccent,
                      width: 70,
                      height: 70,
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
              ),
            ),

            const SizedBox(width: 12),

            // 📝 Thông tin địa điểm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.description,
                    style: const TextStyle(color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
