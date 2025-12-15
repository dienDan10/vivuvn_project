import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/chat_api.dart';
import '../data/dtos/chat_update.dart';
import '../data/dtos/delete_message_request.dart';
import '../data/dtos/get_chat_update_request.dart';
import '../data/dtos/get_messages_request.dart';
import '../data/dtos/get_messages_response.dart';
import '../data/dtos/send_message_request.dart';
import '../data/model/message.dart';
import 'i_chat_service.dart';

final chatServiceProvider = Provider.autoDispose<IChatService>((final ref) {
  final chatApi = ref.watch(chatProvider);
  final chatService = ChatService(chatApi);

  // dispose stream when provider is disposed
  ref.onDispose(() {
    chatService.dispose();
  });

  return chatService;
});

class ChatService implements IChatService {
  final ChatApi _chatApi;
  ChatService(this._chatApi);

  // Polling state
  Timer? _pollingTimer;
  int? _currentItineraryId;
  int _lastMessageId = 0;
  DateTime? _lastPolledAt;
  bool _isPolling = false;

  // Message stream controller
  final StreamController<ChatUpdate> _updateStreamController =
      StreamController<ChatUpdate>.broadcast();
  // Expose the stream for listeners
  @override
  Stream<ChatUpdate> get chatUpdateStream => _updateStreamController.stream;

  @override
  Future<GetMessagesResponse> getMessages({
    required final int itineraryId,
    final int page = 1,
    final int pageSize = 50,
  }) async {
    final request = GetMessagesRequest(
      itineraryId: itineraryId,
      page: page,
      pageSize: pageSize,
    );

    return await _chatApi.getMessages(request);
  }

  @override
  Future<ChatUpdate> getChatUpdates({
    required final int itineraryId,
    required final int lastMessageId,
    final DateTime? lastPolledAt,
  }) async {
    final request = GetChatUpdateRequest(
      itineraryId: itineraryId,
      lastMessageId: lastMessageId,
      lastPolledAt: lastPolledAt,
    );
    return await _chatApi.getChatUpdates(request);
  }

  @override
  Future<Message> sendMessage({
    required final int itineraryId,
    required final String message,
  }) async {
    final request = SendMessageRequest(
      itineraryId: itineraryId,
      message: message,
    );

    final sentMessage = await _chatApi.sendMessage(request);

    // update last message ID after sending
    _lastMessageId = sentMessage.id;

    return sentMessage;
  }

  @override
  Future<void> deleteMessage({
    required final int itineraryId,
    required final int messageId,
  }) async {
    final request = DeleteMessageRequest(
      itineraryId: itineraryId,
      messageId: messageId,
    );
    await _chatApi.deleteMessage(request);
  }

  @override
  void startPolling({
    required final int itineraryId,
    required final int lastMessageId,
    final Duration interval = const Duration(seconds: 3),
  }) {
    if (_isPolling && _currentItineraryId == itineraryId) {
      // Already polling for this itinerary
      return;
    }

    // stop any existing polling
    stopPolling();

    _currentItineraryId = itineraryId;
    _lastMessageId = lastMessageId;
    _isPolling = true;
    _lastPolledAt = DateTime.now();

    // start the timer
    _pollingTimer = Timer.periodic(interval, (_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    if (!_isPolling || _currentItineraryId == null) {
      // if not polling or itinerary ID not set, do nothing
      return;
    }

    final request = GetChatUpdateRequest(
      itineraryId: _currentItineraryId!,
      lastMessageId: _lastMessageId,
      lastPolledAt: _lastPolledAt,
    );

    try {
      final updates = await _chatApi.getChatUpdates(request);
      if (updates.hasUpdates) {
        if (updates.newMessages.isNotEmpty) {
          final newMessages = updates.newMessages;
          // update last message ID
          _lastMessageId = newMessages.first.id;
        }
        // update last polled time
        _lastPolledAt = DateTime.now();
        // add updates to stream
        _updateStreamController.add(updates);
      }
    } catch (e) {
      // Handle error (e.g., log it)
      // For now, we just print the error
    }
  }

  @override
  void dispose() {
    stopPolling();
    _updateStreamController.close();
  }

  @override
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isPolling = false;
    _currentItineraryId = null;
  }

  @override
  void updateLastMessageId(final int messageId) {
    _lastMessageId = messageId;
  }
}
