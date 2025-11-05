import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/chat_api.dart';
import '../data/dtos/delete_message_request.dart';
import '../data/dtos/get_messages_request.dart';
import '../data/dtos/get_messages_response.dart';
import '../data/dtos/get_new_messages_request.dart';
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
  bool _isPolling = false;

  // Message stream controller
  final StreamController<List<Message>> _messageStreamController =
      StreamController<List<Message>>.broadcast();

  // Expose the stream for listeners
  @override
  Stream<List<Message>> get newMessagesStream =>
      _messageStreamController.stream;

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
  Future<List<Message>> getNewMessages({
    required final int itineraryId,
    required final int lastMessageId,
  }) async {
    final request = GetNewMessagesRequest(
      itineraryId: itineraryId,
      lastMessageId: lastMessageId,
    );
    return await _chatApi.getNewMessages(request);
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

    // start the timer
    _pollingTimer = Timer.periodic(interval, (_) {
      _checkForNewMessages();
    });
  }

  Future<void> _checkForNewMessages() async {
    if (!_isPolling || _currentItineraryId == null) {
      // if not polling or itinerary ID not set, do nothing
      return;
    }

    final request = GetNewMessagesRequest(
      itineraryId: _currentItineraryId!,
      lastMessageId: _lastMessageId,
    );

    try {
      final newMessages = await _chatApi.getNewMessages(request);
      if (newMessages.isNotEmpty) {
        // update last message ID
        _lastMessageId = newMessages.first.id;

        // add new messages to stream
        _messageStreamController.add(newMessages);
      }
    } catch (e) {
      // Handle error (e.g., log it)
      // For now, we just print the error
      // print('Error while polling for new messages: $e');
    }
  }

  @override
  void dispose() {
    stopPolling();
    _messageStreamController.close();
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
