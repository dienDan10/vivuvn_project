import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controller/chat_controller.dart';
import '../data/model/message.dart';

class DeleteMessageModal extends ConsumerStatefulWidget {
  final int itineraryId;
  final Message message;
  const DeleteMessageModal({
    super.key,
    required this.itineraryId,
    required this.message,
  });

  @override
  ConsumerState<DeleteMessageModal> createState() => _DeleteMessageModalState();
}

class _DeleteMessageModalState extends ConsumerState<DeleteMessageModal> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Xoá tin nhắn',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                ref
                    .read(chatControllerProvider(widget.itineraryId).notifier)
                    .deleteMessage(widget.message.id);
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Huỷ'),
              onTap: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
