import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/image_timeout_controller.dart';

class PlaceCardImage extends ConsumerStatefulWidget {
  const PlaceCardImage({required this.imageUrl, this.size = 80, super.key});

  final String? imageUrl;
  final double size;

  @override
  ConsumerState<PlaceCardImage> createState() => _PlaceCardImageState();
}

class _PlaceCardImageState extends ConsumerState<PlaceCardImage> {
  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(imageTimeoutControllerProvider(widget.imageUrl!).notifier)
            .startTimeout(const Duration(seconds: 10));
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return _buildPlaceholder(colorScheme);
    }

    final timeoutState =
        ref.watch(imageTimeoutControllerProvider(widget.imageUrl!));

    if (timeoutState.timedOut) {
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
          ref
              .read(imageTimeoutControllerProvider(widget.imageUrl!).notifier)
              .cancelTimeout();
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
          ref
              .read(imageTimeoutControllerProvider(widget.imageUrl!).notifier)
              .cancelTimeout();
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
