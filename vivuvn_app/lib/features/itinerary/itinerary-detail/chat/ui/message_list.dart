import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controller/chat_controller.dart';
import '../data/model/message.dart';
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

  bool _shouldShowDateSeparator(
    final Message currentMessage,
    final Message? previousMessage,
  ) {
    if (previousMessage == null) return true;

    final currentDate = DateTime(
      currentMessage.createdAt.year,
      currentMessage.createdAt.month,
      currentMessage.createdAt.day,
    );

    final previousDate = DateTime(
      previousMessage.createdAt.year,
      previousMessage.createdAt.month,
      previousMessage.createdAt.day,
    );

    return !currentDate.isAtSameMomentAs(previousDate);
  }

  String _formatDateSeparator(final DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate.isAtSameMomentAs(today)) {
      return 'Hôm nay';
    } else if (messageDate.isAtSameMomentAs(yesterday)) {
      return 'Hôm qua';
    } else {
      return DateFormat('dd MMMM, yyyy', 'vi').format(date);
    }
  }

  Widget _buildDateSeparator(final String dateText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

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
        final previousMessage = index < messages.length - 1
            ? messages[index + 1]
            : null;
        final bool showDateSeparator = _shouldShowDateSeparator(
          message,
          previousMessage,
        );

        final bool isLastInSequence =
            index == messages.length - 1 ||
            messages[index + 1].memberId != message.memberId;

        final bool isFirstInSequence =
            index == 0 || messages[index - 1].memberId != message.memberId;

        final bool isAloneInSequence = isFirstInSequence && isLastInSequence;

        final bool isMiddleInSequence = !isFirstInSequence && !isLastInSequence;

        // Build message bubble based on position in sequence
        Widget messageBubble;
        if (isAloneInSequence) {
          messageBubble = MessageBubble.alone(message: message);
        } else if (isFirstInSequence) {
          messageBubble = MessageBubble.first(message: message);
        } else if (isMiddleInSequence) {
          messageBubble = MessageBubble.middle(message: message);
        } else {
          // isLastInSequence
          messageBubble = MessageBubble.last(message: message);
        }

        // Add date separator if needed
        if (showDateSeparator) {
          return Column(
            children: [
              messageBubble,
              _buildDateSeparator(_formatDateSeparator(message.createdAt)),
            ],
          );
        }

        return messageBubble;
      },
    );
  }
}
