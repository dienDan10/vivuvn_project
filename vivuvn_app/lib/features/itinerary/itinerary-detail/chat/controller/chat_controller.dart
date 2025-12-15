import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../data/dtos/chat_update.dart';
import '../data/model/message.dart';
import '../service/chat_service.dart';
import '../service/i_chat_service.dart';
import '../state/chat_state.dart';

final chatControllerProvider =
    AutoDisposeNotifierProviderFamily<ChatController, ChatState, int>(
      ChatController.new,
    );

class ChatController extends AutoDisposeFamilyNotifier<ChatState, int> {
  late int itineraryId;
  late final IChatService _chatService;
  StreamSubscription<ChatUpdate>? _updateSubscription;

  @override
  ChatState build(final int arg) {
    _chatService = ref.watch(chatServiceProvider);
    itineraryId = arg;

    // Dispose resources when the controller is disposed
    ref.onDispose(() {
      _dispose();
    });

    // load initial messages after build completes
    Future.microtask(() => loadMessages());

    // listen to new messages stream
    _listenToChatUpdate();

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

  void _listenToChatUpdate() {
    _updateSubscription = _chatService.chatUpdateStream.listen(
      (final chatUpdate) {
        if (chatUpdate.newMessages.isEmpty &&
            chatUpdate.deletedMessageIds.isEmpty) {
          return;
        }

        final updatedMessages = List<Message>.from(state.messages);

        // remove deleted messages
        if (chatUpdate.deletedMessageIds.isNotEmpty) {
          updatedMessages.removeWhere(
            (final message) =>
                chatUpdate.deletedMessageIds.contains(message.id),
          );
        }

        // add new messages
        updatedMessages.insertAll(0, chatUpdate.newMessages);

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
        // Error handled silently
      },
    );
  }

  List<Message> _removeDuplicateMessages(final List<Message> messages) {
    final seen = <int>{};
    return messages.where((final message) {
      if (seen.contains(message.id)) {
        return false;
      }
      seen.add(message.id);
      return true;
    }).toList();
  }

  // Load more messages for pagination
  Future<void> loadMoreMessages() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;

      final response = await _chatService.getMessages(
        itineraryId: itineraryId,
        page: nextPage,
        pageSize: 50,
      );

      final updatedMessages = [...state.messages, ...response.messages];

      // update state
      state = state.copyWith(
        messages: updatedMessages,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        totalMessages: updatedMessages.length,
        hasMore: response.hasNextPage,
      );
    } on DioException catch (e) {
      final String errMessage = DioExceptionHandler.handleException(e);
      state = state.copyWith(errorMessage: errMessage);
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred.');
    } finally {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> sendMessage(final String messageText) async {
    if (messageText.trim().isEmpty) return;

    state = state.copyWith(isSending: true);

    // create a temporary message ID for optimistic UI update
    final tempMessageId = DateTime.now().millisecondsSinceEpoch;

    final tempMessage = Message(
      id: tempMessageId,
      memberId: 0, // assuming 0 for own user, adjust as needed
      email: '',
      username: 'You',
      photo: null,
      message: messageText,
      createdAt: DateTime.now(),
      isOwnMessage: true,
    );

    // Optimistically add the message to the state
    final optimisticMessages = [tempMessage, ...state.messages];
    state = state.copyWith(
      messages: optimisticMessages,
      totalMessages: optimisticMessages.length,
    );

    try {
      final sentMessage = await _chatService.sendMessage(
        itineraryId: itineraryId,
        message: messageText,
      );

      // Replace the temporary message with the one returned from the server
      final updatedMessages = state.messages.map((final message) {
        if (message.id == tempMessageId) {
          return sentMessage;
        }
        return message;
      }).toList();

      // update state
      state = state.copyWith(messages: updatedMessages);

      // update last message ID in chat service
      _chatService.updateLastMessageId(sentMessage.id);
    } on DioException catch (e) {
      // Remove the optimistic message on failure
      final revertedMessages = state.messages
          .where((final message) => message.id != tempMessageId)
          .toList();

      final String errMessage = DioExceptionHandler.handleException(e);
      state = state.copyWith(
        errorMessage: errMessage,
        messages: revertedMessages,
        totalMessages: revertedMessages.length,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred.');
    } finally {
      state = state.copyWith(isSending: false);
    }
  }

  Future<void> deleteMessage(final int messageId) async {
    try {
      // Optimistically remove from UI
      final updatedMessages = state.messages
          .where((final m) => m.id != messageId)
          .toList();
      state = state.copyWith(
        messages: updatedMessages,
        totalMessages: updatedMessages.length,
      );

      await _chatService.deleteMessage(
        itineraryId: itineraryId,
        messageId: messageId,
      );
    } on DioException catch (e) {
      final String errMessage = DioExceptionHandler.handleException(e);
      state = state.copyWith(errorMessage: errMessage);
      await loadMessages();
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred.');
      await loadMessages();
    }
  }

  /// Refresh messages
  Future<void> refresh() async {
    // Stop polling
    _chatService.stopPolling();

    // Reload messages
    await loadMessages(page: 1);
  }

  /// Dispose resources
  void _dispose() {
    // Cancel stream subscription
    _updateSubscription?.cancel();
    _updateSubscription = null;

    // Stop polling and dispose the service
    _chatService.dispose();
  }
}
