import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_picture_image.dart';

class ProfilePictureContainer extends ConsumerWidget {
  const ProfilePictureContainer({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary,
          width: 3,
        ),
      ),
      child: const ClipOval(
        child: ProfilePictureImage(),
      ),
    );
  }
}

