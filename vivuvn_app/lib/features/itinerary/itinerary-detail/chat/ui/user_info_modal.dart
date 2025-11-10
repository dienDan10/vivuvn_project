import 'package:flutter/material.dart';

import '../../../../../common/helper/image_util.dart';
import '../data/model/message.dart';

class UserInfoModal extends StatelessWidget {
  final Message message;

  const UserInfoModal({super.key, required this.message});

  static void show(final BuildContext context, final Message message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      builder: (final context) => UserInfoModal(message: message),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Avatar
          ImageUtil.buildAvatarWidget(imageUrl: message.photo, radius: 50),
          const SizedBox(height: 16),

          // User name
          Text(
            message.username,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            message.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
