import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LocationImageSlider extends StatelessWidget {
  final List<String> photos;
  final int currentIndex;
  final Function(int, CarouselPageChangedReason) onPageChanged;
  final VoidCallback onBackPressed;

  const LocationImageSlider({
    super.key,
    required this.photos,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onBackPressed,
  });

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Carousel slider thay vì PageView
          CarouselSlider.builder(
            itemCount: photos.isEmpty ? 1 : photos.length,
            itemBuilder: (final context, final index, final realIndex) {
              final url = photos.isNotEmpty
                  ? photos[index]
                  : 'https://via.placeholder.com/400x250.png?text=No+Image';
              return CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, final __) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              );
            },
            options: CarouselOptions(
              height: 280,
              viewportFraction: 1,
              enableInfiniteScroll: photos.length > 1,
              autoPlay: photos.length > 1,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              onPageChanged: onPageChanged,
            ),
          ),

          // Gradient overlay
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent, Colors.black26],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Nút Back
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              radius: 22,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBackPressed,
              ),
            ),
          ),

          // Indicator
          if (photos.length > 1)
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  photos.length,
                  (final index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.white
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
