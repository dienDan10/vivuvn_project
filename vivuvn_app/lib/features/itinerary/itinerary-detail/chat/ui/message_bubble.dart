import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../common/helper/image_util.dart';
import '../data/model/message.dart';
import 'delete_message_modal.dart';
import 'user_info_modal.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble.alone({
    super.key,
    required this.message,
    required this.itineraryId,
  }) : isAloneInSequence = true,
       isFirstInSequence = false,
       isMiddleInSequence = false,
       isLastInSequence = false;

  const MessageBubble.first({
    super.key,
    required this.message,
    required this.itineraryId,
  }) : isFirstInSequence = true,
       isAloneInSequence = false,
       isMiddleInSequence = false,
       isLastInSequence = false;

  const MessageBubble.middle({
    super.key,
    required this.message,
    required this.itineraryId,
  }) : isFirstInSequence = false,
       isAloneInSequence = false,
       isMiddleInSequence = true,
       isLastInSequence = false;

  const MessageBubble.last({
    super.key,
    required this.message,
    required this.itineraryId,
  }) : isFirstInSequence = false,
       isAloneInSequence = false,
       isMiddleInSequence = false,
       isLastInSequence = true;

  final bool isAloneInSequence;
  final bool isFirstInSequence;
  final bool isMiddleInSequence;
  final bool isLastInSequence;
  final Message message;
  final int itineraryId;

  BorderRadius _getBorderRadius() {
    final isMe = message.isOwnMessage;

    if (isAloneInSequence) {
      return const BorderRadius.all(Radius.circular(20));
    } else if (isFirstInSequence) {
      return BorderRadius.only(
        topLeft: Radius.circular(isMe ? 20 : 0),
        topRight: Radius.circular(isMe ? 0 : 20),
        bottomLeft: const Radius.circular(20),
        bottomRight: const Radius.circular(20),
      );
    } else if (isMiddleInSequence) {
      return BorderRadius.only(
        topLeft: Radius.circular(isMe ? 20 : 0),
        topRight: Radius.circular(isMe ? 0 : 20),
        bottomLeft: Radius.circular(isMe ? 20 : 0),
        bottomRight: Radius.circular(isMe ? 0 : 20),
      );
    } else if (isLastInSequence) {
      return BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
        bottomLeft: Radius.circular(isMe ? 20 : 0),
        bottomRight: Radius.circular(isMe ? 0 : 20),
      );
    } else {
      return const BorderRadius.all(Radius.circular(20));
    }
  }

  void _onAvatarTap(final BuildContext context) {
    UserInfoModal.show(context, message);
  }

  void _onMessageLongPress(final BuildContext context, final WidgetRef ref) {
    final canDelete = message.isOwnMessage;

    if (!canDelete) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (final BuildContext context) {
        return DeleteMessageModal(itineraryId: itineraryId, message: message);
      },
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isMe = message.isOwnMessage;

    return Column(
      children: [
        if (isAloneInSequence || isLastInSequence) const SizedBox(height: 16),
        if (isFirstInSequence || isMiddleInSequence) const SizedBox(height: 2),
        Row(
          spacing: 8,
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // display user avatar if this is
            //the first message in a sequence
            // and the message is from another user
            if ((isAloneInSequence || isFirstInSequence) && !isMe)
              GestureDetector(
                onTap: () => _onAvatarTap(context),
                child: ImageUtil.buildAvatarWidget(
                  imageUrl: message.photo,
                  radius: 16,
                ),
              )
            else if (!isMe)
              const SizedBox(width: 32),

            GestureDetector(
              onLongPress: () => _onMessageLongPress(context, ref),
              child: Container(
                decoration: BoxDecoration(
                  color: !isMe
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: _getBorderRadius(),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 16,
                        color: isMe
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    if (isAloneInSequence || isFirstInSequence)
                      Text(
                        DateFormat('HH:mm').format(message.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: isMe
                              ? Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.7)
                              : Theme.of(context).colorScheme.onPrimaryContainer
                                    .withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
