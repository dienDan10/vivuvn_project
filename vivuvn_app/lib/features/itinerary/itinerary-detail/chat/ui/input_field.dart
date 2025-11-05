import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/chat_controller.dart';

class InputField extends ConsumerStatefulWidget {
  final int itineraryId;
  const InputField({super.key, required this.itineraryId});

  @override
  ConsumerState<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends ConsumerState<InputField> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    await ref
        .read(chatControllerProvider(widget.itineraryId).notifier)
        .sendMessage(text);
    //_scrollToBottom();
  }

  @override
  Widget build(final BuildContext context) {
    final isSending = ref.watch(
      chatControllerProvider(
        widget.itineraryId,
      ).select((final state) => state.isSending),
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 20),
      child: Container(
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message...',
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                enabled: !isSending,
              ),
            ),
            IconButton(
              icon: isSending
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              onPressed: isSending ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
