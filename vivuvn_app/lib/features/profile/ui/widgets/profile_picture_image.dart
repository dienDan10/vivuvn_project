import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/profile_controller.dart';
import 'profile_picture_placeholder.dart';

class ProfilePictureImage extends ConsumerWidget {
  const ProfilePictureImage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final user = ref.watch(
      profileControllerProvider.select((final s) => s.user),
    );

    final hasPhoto = user?.userPhoto != null && user!.userPhoto!.isNotEmpty;

    if (!hasPhoto) {
      return const ProfilePicturePlaceholder();
    }

    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/image-placeholder.jpeg',
      image: user.userPhoto!,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      imageErrorBuilder: (final context, final error, final stackTrace) {
        return const ProfilePicturePlaceholder();
      },
    );
  }
}

