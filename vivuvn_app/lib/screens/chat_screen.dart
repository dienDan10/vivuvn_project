import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/itinerary/itinerary-detail/chat/ui/chat_layout.dart';

class ChatScreen extends ConsumerWidget {
  final int itineraryId;
  const ChatScreen({super.key, required this.itineraryId});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ChatLayout(itineraryId: itineraryId);
  }
}
