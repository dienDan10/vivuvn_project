import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/chat_controller.dart';
import '../state/chat_state.dart';
import 'message_bubble.dart';

class MessageList extends ConsumerStatefulWidget {
  final int itineraryId;
  const MessageList({super.key, required this.itineraryId});

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref
          .read(chatControllerProvider(widget.itineraryId).notifier)
          .loadMoreMessages();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final chatStatus = ref.watch(
      chatControllerProvider(
        widget.itineraryId,
      ).select((final state) => state.status),
    );
    final errorMessage = ref.watch(
      chatControllerProvider(
        widget.itineraryId,
      ).select((final state) => state.errorMessage),
    );
    final messages = ref.watch(
      chatControllerProvider(
        widget.itineraryId,
      ).select((final state) => state.messages),
    );
    final isLoadingMore = ref.watch(
      chatControllerProvider(
        widget.itineraryId,
      ).select((final state) => state.isLoadingMore),
    );

    if (chatStatus == ChatStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatStatus == ChatStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(chatControllerProvider(widget.itineraryId).notifier)
                    .refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Start the conversation!'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (final context, final index) {
        if (isLoadingMore && index == messages.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final message = messages[index];
        final bool isLastInSequence =
            index == messages.length - 1 ||
            messages[index + 1].memberId != message.memberId;

        final bool isFirstInSequence =
            index == 0 || messages[index - 1].memberId != message.memberId;

        final bool isAloneInSequence = isFirstInSequence && isLastInSequence;

        final bool isMiddleInSequence = !isFirstInSequence && !isLastInSequence;

        // Build appropriate message bubble based on position in sequence
        if (isAloneInSequence) {
          return MessageBubble.alone(message: message);
        }

        if (isFirstInSequence) {
          return MessageBubble.first(message: message);
        }

        if (isMiddleInSequence) {
          return MessageBubble.middle(message: message);
        }

        // isLastInSequence
        return MessageBubble.last(message: message);
      },
    );
  }
}
