import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaceCardImage extends StatefulWidget {
  const PlaceCardImage({required this.imageUrl, this.size = 80, super.key});

  final String? imageUrl;
  final double size;

  @override
  State<PlaceCardImage> createState() => _PlaceCardImageState();
}

class _PlaceCardImageState extends State<PlaceCardImage> {
  bool _hasTimedOut = false;
  Timer? _timeoutTimer;
  static const _loadTimeout = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _startTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(_loadTimeout, () {
      if (mounted) {
        setState(() {
          _hasTimedOut = true;
        });
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return _buildPlaceholder(colorScheme);
    }

    // Nếu đã timeout, hiển thị placeholder luôn
    if (_hasTimedOut) {
      return _buildPlaceholder(colorScheme);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl!,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        imageBuilder: (final context, final imageProvider) {
          // Ảnh load thành công → Cancel timeout
          _timeoutTimer?.cancel();
          return Image(
            image: imageProvider,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
          );
        },
        progressIndicatorBuilder:
            (final context, final url, final downloadProgress) => Container(
              width: widget.size,
              height: widget.size,
              color: colorScheme.primaryContainer,
              child: Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  strokeWidth: 2,
                ),
              ),
            ),
        errorWidget: (final context, final url, final error) {
          // Error → Cancel timeout và hiện placeholder
          _timeoutTimer?.cancel();
          return _buildPlaceholder(colorScheme);
        },
        // Lazy loading configuration
        memCacheWidth: (widget.size * 2).toInt(),
        memCacheHeight: (widget.size * 2).toInt(),
        maxWidthDiskCache: (widget.size * 3).toInt(),
        maxHeightDiskCache: (widget.size * 3).toInt(),
      ),
    );
  }

  /// Placeholder khi không có ảnh hoặc ảnh lỗi
  Widget _buildPlaceholder(final ColorScheme colorScheme) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image,
        color: colorScheme.onPrimaryContainer,
        size: widget.size * 0.45,
      ),
    );
  }
}
