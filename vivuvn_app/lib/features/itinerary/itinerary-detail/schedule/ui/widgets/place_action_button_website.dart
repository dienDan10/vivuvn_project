import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/location.dart';

class PlaceActionButtonWebsite extends StatelessWidget {
  final Location location;
  const PlaceActionButtonWebsite({super.key, required this.location});

  Future<void> _openWebsite(final BuildContext context) async {
    final url = location.websiteUri;

    if (url == null || url.isEmpty) {
      if (context.mounted) {
        CherryToast.error(
          title: const Text('Không có địa chỉ website'),
          toastPosition: Position.top,
        ).show(context);
      }
      return;
    }

    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      if (context.mounted) {
        CherryToast.error(
          title: const Text('Không thể mở website'),
          toastPosition: Position.top,
        ).show(context);
      }
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: () => _openWebsite(context),
      icon: const Icon(Icons.language_outlined, size: 20),
      label: const Text(
        'Website',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
