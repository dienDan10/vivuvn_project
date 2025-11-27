import 'package:flutter/material.dart';

import '../../../overview/ui/widgets/favourite_place/place_card_image.dart';

class SuggestedPlaceItem extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback? onTap;

  const SuggestedPlaceItem({
    super.key,
    required this.title,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            PlaceCardImage(imageUrl: imageUrl, size: 60),

            const SizedBox(width: 8),

            // Tiêu đề địa điểm
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Nút cộng
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 18, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
