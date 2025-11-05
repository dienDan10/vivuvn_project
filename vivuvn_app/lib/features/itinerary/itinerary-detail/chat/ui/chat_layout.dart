import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/chat_controller.dart';
import 'input_field.dart';
import 'message_list.dart';

class ChatLayout extends ConsumerWidget {
  final int itineraryId;
  const ChatLayout({super.key, required this.itineraryId});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final totalMessages = ref.watch(
      chatControllerProvider(
        itineraryId,
      ).select((final state) => state.totalMessages),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trò chuyện'),
            Text(
              '$totalMessages tin nhắn',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              ref.read(chatControllerProvider(itineraryId).notifier).refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //Message list
          Expanded(child: MessageList(itineraryId: itineraryId)),

          // Input field
          InputField(itineraryId: itineraryId),
        ],
      ),
    );
  }
}
