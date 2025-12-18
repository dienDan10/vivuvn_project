import 'package:flutter/material.dart';

class ProfilePicturePreviewDialog extends StatelessWidget {
  const ProfilePicturePreviewDialog({super.key, required this.imageUrl});

  final String imageUrl;

  static Future<void> show(
    final BuildContext context,
    final String imageUrl,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (final ctx) => ProfilePicturePreviewDialog(imageUrl: imageUrl),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (final context, final error, final stackTrace) {
                    return const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
