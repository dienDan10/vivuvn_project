import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePicturePlaceholder extends ConsumerWidget {
  const ProfilePicturePlaceholder({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[300],
      child: const Icon(
        Icons.person,
        size: 60,
        color: Colors.grey,
      ),
    );
  }
}

