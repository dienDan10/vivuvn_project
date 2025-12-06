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
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with gradient overlay
          Stack(
            children: [
              SizedBox(
                height: 100,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: PlaceCardImage(imageUrl: imageUrl, size: 100),
                ),
              ),

              // Add button overlay
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_circle,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Title section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.3,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
