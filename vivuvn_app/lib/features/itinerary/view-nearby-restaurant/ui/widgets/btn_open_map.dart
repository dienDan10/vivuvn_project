import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonOpenMap extends StatelessWidget {
  final String mapUrl;
  const ButtonOpenMap({super.key, required this.mapUrl});

  Future<void> _openMap() async {
    if (mapUrl.isEmpty) {
      return;
    }

    final Uri url = Uri.parse(mapUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: _openMap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icons
            SvgPicture.asset(
              'assets/icons/marker.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(width: 4),

            // Text
            const Text(
              'Bản đồ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
