import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../schedule/model/location.dart';

class LocationDetailModal extends StatefulWidget {
  final Location location;
  const LocationDetailModal({super.key, required this.location});

  @override
  State<LocationDetailModal> createState() => _LocationDetailModalState();
}

class _LocationDetailModalState extends State<LocationDetailModal> {
  // final int _currentImageIndex = 0;

  Future<void> _openDirections(final String uri) async {
    if (uri.isEmpty) return;

    final Uri url = Uri.parse(uri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWebsite(final String uri) async {
    if (uri.isEmpty) return;

    final Uri url = Uri.parse(uri);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImages = widget.location.photos.isNotEmpty;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (final context, final scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    // Image Carousel
                    if (hasImages)
                      CarouselSlider.builder(
                        itemCount: widget.location.photos.length,
                        itemBuilder: (final context, final itemIndex, _) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  'assets/images/image-placeholder.jpeg',
                              image: widget.location.photos[itemIndex],
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                              imageErrorBuilder:
                                  (
                                    final context,
                                    final error,
                                    final stackTrace,
                                  ) {
                                    return Container(
                                      width: double.infinity,
                                      height: 250,
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    );
                                  },
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 250,
                          enlargeCenterPage: true,
                          enableInfiniteScroll:
                              widget.location.photos.length > 1,
                          viewportFraction: 0.9,
                          enlargeFactor: 0.2,
                          autoPlay: widget.location.photos.length > 1,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 800,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 200,
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.location_on,
                          size: 80,
                          color: colorScheme.primary,
                        ),
                      ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location name and province chip
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.location.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_city,
                                      size: 14,
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.location.provinceName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSecondaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Rating section with enhanced design
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.tertiaryContainer,
                                  colorScheme.tertiaryContainer.withValues(
                                    alpha: 0.5,
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: colorScheme.tertiary,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.location.rating
                                                .toStringAsFixed(1),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme
                                                  .onTertiaryContainer,
                                            ),
                                          ),
                                          if (widget.location.ratingCount !=
                                              null)
                                            Text(
                                              '(${widget.location.ratingCount})',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: colorScheme
                                                    .onTertiaryContainer
                                                    .withValues(alpha: 0.8),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      SvgPicture.asset(
                                        'assets/images/google.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Description section
                          if (widget.location.description.isNotEmpty) ...[
                            Text(
                              'Mô tả',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.location.description,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Information section header
                          Text(
                            'Thông tin',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Address section
                          _buildInfoSection(
                            context,
                            icon: Icons.location_on_outlined,
                            title: 'Địa chỉ',
                            content: widget.location.address,
                          ),

                          // Coordinates section
                          if (widget.location.latitude != null &&
                              widget.location.longitude != null)
                            _buildInfoSection(
                              context,
                              icon: Icons.my_location_outlined,
                              title: 'Tọa độ',
                              content:
                                  '${widget.location.latitude!.toStringAsFixed(6)}, ${widget.location.longitude!.toStringAsFixed(6)}',
                            ),

                          // Website section
                          if (widget.location.websiteUri != null &&
                              widget.location.websiteUri!.isNotEmpty)
                            _buildInfoSection(
                              context,
                              icon: Icons.language_outlined,
                              title: 'Website',
                              content: widget.location.websiteUri!,
                              isLink: true,
                              onTap: () =>
                                  _openWebsite(widget.location.websiteUri!),
                            ),

                          const SizedBox(height: 32),

                          // Action buttons with enhanced design
                          Row(
                            children: [
                              // Directions button
                              if (widget.location.directionsUri != null)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _openDirections(
                                      widget.location.directionsUri!,
                                    ),
                                    icon: const Icon(
                                      Icons.directions,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      'Chỉ đường',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: colorScheme.primary,
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.location.directionsUri != null &&
                                  widget.location.placeUri != null)
                                const SizedBox(width: 12),

                              // Google Maps button
                              if (widget.location.placeUri != null)
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () =>
                                        _openWebsite(widget.location.placeUri!),
                                    icon: const Icon(Icons.map, size: 20),
                                    label: const Text(
                                      'Xem trên Maps',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: colorScheme.onPrimary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
    final BuildContext context, {
    required final IconData icon,
    required final String title,
    required final String content,
    final bool isLink = false,
    final VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                isLink
                    ? InkWell(
                        onTap: onTap,
                        child: Text(
                          content,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : Text(
                        content,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
