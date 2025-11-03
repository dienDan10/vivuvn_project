import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../detail/controller/itinerary_detail_controller.dart';
import '../data/model/message.dart';
import '../service/chat_service.dart';
import '../service/i_chat_service.dart';
import '../state/chat_state.dart';

class ChatController extends AutoDisposeNotifier<ChatState> {
  late final int itineraryId;
  late final IChatService _chatService;
  StreamSubscription<List<Message>>? _messageSubscription;

  @override
  ChatState build() {
    _chatService = ref.watch(chatServiceProvider);
    itineraryId = ref.read(itineraryDetailControllerProvider).itineraryId!;

    // load initial messages
    loadMessages();

    // listen to new messages stream
    _listenToNewMessages();

    return ChatState();
  }

  // Load initial messages
  Future<void> loadMessages({final int page = 1}) async {
    state = state.copyWith(status: ChatStatus.loading, errorMessage: null);

    try {
      final response = await _chatService.getMessages(
        itineraryId: itineraryId,
        page: page,
        pageSize: 50,
      );

      // update state
      state = state.copyWith(
        status: ChatStatus.loaded,
        messages: response.messages,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        totalMessages: response.totalMessages,
        hasMore: response.hasNextPage,
      );

      // start polling for new messages
      if (response.messages.isNotEmpty) {
        final lastMessageId = response.messages.first.id;

        _chatService.startPolling(
          itineraryId: itineraryId,
          lastMessageId: lastMessageId,
        );
      } else {
        _chatService.startPolling(itineraryId: itineraryId, lastMessageId: 0);
      }
    } on DioException catch (e) {
      final String errMessage = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: errMessage,
      );
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'An unexpected error occurred.',
      );
    } finally {
      if (state.status != ChatStatus.error) {
        state = state.copyWith(status: ChatStatus.loaded);
      }
    }
  }

  void _listenToNewMessages() {
    _messageSubscription = _chatService.newMessagesStream.listen(
      (final newMessages) {
        if (newMessages.isEmpty) return;

        final updatedMessages = [...newMessages, ...state.messages];

        // remove duplicated messages (just for safety)
        final uniqueMessages = _removeDuplicateMessages(updatedMessages);

        // update state
        state = state.copyWith(
          messages: uniqueMessages,
          totalMessages: uniqueMessages.length,
        );

        // update last message ID in chat service
        _chatService.updateLastMessageId(uniqueMessages.first.id);
      },
      onError: (final error) {
        print('⚠️ Stream error: $error');
      },
    );
  }

  _removeDuplicateMessages(final List<Message> updatedMessages) {}
}
