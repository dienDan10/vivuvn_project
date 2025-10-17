import 'package:flutter/material.dart';

import 'custom_icon_btn.dart';

class CreateItineraryHeader extends StatelessWidget {
  const CreateItineraryHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        // Back button
        CustomIconButton(
          iconPath: 'assets/icons/x-mark.svg',
          onPressed: () {
            Navigator.of(context).pop();
          },
          iconSize: 10,
        ),
        // Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: Text(
                'Tạo một chuyến đi mới',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
