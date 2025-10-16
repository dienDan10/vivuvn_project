import 'package:flutter/material.dart';

import '../../../../common/helper/app_constants.dart';
import 'btn_back.dart';
import 'btn_settings.dart';

class ExpandedAppbarBackground extends StatelessWidget {
  const ExpandedAppbarBackground({super.key});

  @override
  Widget build(final BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image with gradient overlay
        DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Image.network(
            'https://picsum.photos/seed/250/400/300',
            fit: BoxFit.cover,
          ),
        ),

        // Icons - back and settings
        Positioned(
          top: MediaQuery.of(context).padding.top + 7,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: MediaQuery.of(context).size.width,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back icon
                ButtonBack(),

                // setting icon
                ButtonSettings(),
              ],
            ),
          ),
        ),

        // Title - centered
        const Positioned(
          top: appbarExpandedHeight * 0.4,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ngày định mệnh của chúng ta đã đến',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '22/10 → 25/10, 2025',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
