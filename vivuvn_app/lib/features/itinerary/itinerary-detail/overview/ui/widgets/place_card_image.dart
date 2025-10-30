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
  bool _timedOut = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      _timer = Timer(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() => _timedOut = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.imageUrl == null || widget.imageUrl!.isEmpty || _timedOut) {
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
          _timer?.cancel();
          return Image(
            image: imageProvider,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
          );
        },
        placeholder: (final context, final url) => Container(
          width: widget.size,
          height: widget.size,
          color: colorScheme.primaryContainer,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        errorWidget: (final context, final url, final error) {
          _timer?.cancel();
          return _buildPlaceholder(colorScheme);
        },
      ),
    );
  }

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
