// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../data/model/message.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState {
  final List<Message> messages;
  final ChatStatus status;
  final int currentPage;
  final int totalPages;
  final int totalMessages;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isSending;
  final String? errorMessage;

  ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalMessages = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isSending = false,
    this.errorMessage,
  });

  ChatState copyWith({
    final List<Message>? messages,
    final ChatStatus? status,
    final int? currentPage,
    final int? totalPages,
    final int? totalMessages,
    final bool? hasMore,
    final bool? isLoadingMore,
    final bool? isSending,
    final String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalMessages: totalMessages ?? this.totalMessages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
