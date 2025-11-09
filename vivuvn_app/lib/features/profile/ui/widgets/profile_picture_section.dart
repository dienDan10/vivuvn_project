import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_picture_container.dart';
import 'profile_picture_edit_button.dart';
import 'profile_picture_loading_overlay.dart';

class ProfilePictureSection extends ConsumerWidget {
  const ProfilePictureSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        ProfilePictureContainer(),
        ProfilePictureLoadingOverlay(),
        ProfilePictureEditButton(),
      ],
    );
  }
}

