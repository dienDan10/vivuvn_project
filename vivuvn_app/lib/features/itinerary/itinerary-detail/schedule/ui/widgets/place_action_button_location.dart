import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceActionButtonLocation extends StatelessWidget {
  final String url;
  final bool compact;
  const PlaceActionButtonLocation({
    super.key,
    required this.url,
    this.compact = false,
  });

  Future<void> _openMap() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final horizontalPadding = compact ? 10.0 : 12.0;
    final verticalPadding = compact ? 6.0 : 8.0;
    final iconSize = compact ? 16.0 : 20.0;
    final fontSize = compact ? 12.0 : 14.0;
    return GestureDetector(
      onTap: () => _openMap(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: iconSize,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Vị trí',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
