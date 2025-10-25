import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helper/app_constants.dart';
import '../../model/restaurant.dart';
import 'btn_add_to_itinerary.dart';
import 'btn_open_map.dart';

class RestaurantDetailModal extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantDetailModal({super.key, required this.restaurant});

  @override
  Widget build(final BuildContext context) {
    final priceLevel = restaurant.priceLevel;
    final priceLevelString = priceLevelIndicators[priceLevel] ?? 'Unknown';

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (final context, final scrollController) => Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          controller: scrollController,
          children: [
            // Title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),

            // Restaurant Images
            const SizedBox(height: 16),
            if (restaurant.photos.isNotEmpty)
              CarouselSlider.builder(
                itemCount: restaurant.photos.length,
                itemBuilder: (final context, final itemIndex, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/image-placeholder.jpeg',
                      image: restaurant.photos.isNotEmpty
                          ? restaurant.photos[itemIndex]
                          : 'assets/images/image-placeholder.jpeg',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      imageErrorBuilder:
                          (final context, final error, final stackTrace) {
                            return Image.asset(
                              'assets/images/image-placeholder.jpeg',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            );
                          },
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.9,
                  enlargeFactor: 0.2,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
              ),

            const SizedBox(height: 16),
            // Restaurant Details
            // Rating row
            Row(
              children: [
                // Star Icon
                const Icon(Icons.star, color: Colors.orangeAccent, size: 20),
                const SizedBox(width: 10),
                // Rating Text
                Text(
                  '${restaurant.rating}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
                // Rating count
                const SizedBox(width: 4),
                Text('(${restaurant.userRatingCount})'),

                // google image
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/images/google.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Address row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SvgPicture.asset(
                    'assets/icons/restaurant.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    restaurant.address,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price Level row
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    children: [
                      const TextSpan(text: 'Price Level: '),
                      TextSpan(
                        text: priceLevelString,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: restaurant.getPriceLevelColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Map Button
                ButtonOpenMap(mapUrl: restaurant.googleMapsUri ?? ''),

                const SizedBox(width: 12),

                // Add to Itinerary Button
                const ButtonAddToItinerary(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
