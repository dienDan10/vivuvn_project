import 'dart:convert';

import '../model/message.dart';

class GetMessagesResponse {
  final List<Message> messages;
  final int currentPage;
  final int totalPages;
  final int totalMessages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  GetMessagesResponse({
    required this.messages,
    required this.currentPage,
    required this.totalPages,
    required this.totalMessages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  GetMessagesResponse copyWith({
    final List<Message>? messages,
    final int? currentPage,
    final int? totalPages,
    final int? totalMessages,
    final bool? hasNextPage,
    final bool? hasPreviousPage,
  }) {
    return GetMessagesResponse(
      messages: messages ?? this.messages,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalMessages: totalMessages ?? this.totalMessages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messages': messages.map((final x) => x.toMap()).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalMessages': totalMessages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  factory GetMessagesResponse.fromMap(final Map<String, dynamic> map) {
    return GetMessagesResponse(
      messages: List<Message>.from(
        (map['messages'] as List<dynamic>).map<Message>(
          (final x) => Message.fromMap(x as Map<String, dynamic>),
        ),
      ),
      currentPage: map['currentPage'] as int,
      totalPages: map['totalPages'] as int,
      totalMessages: map['totalMessages'] as int,
      hasNextPage: map['hasNextPage'] as bool,
      hasPreviousPage: map['hasPreviousPage'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMessagesResponse.fromJson(final String source) =>
      GetMessagesResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetMessagesResponse(messages: $messages, currentPage: $currentPage, totalPages: $totalPages, totalMessages: $totalMessages, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage)';
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is GetMessagesResponse &&
        other.messages == messages &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages &&
        other.totalMessages == totalMessages &&
        other.hasNextPage == hasNextPage &&
        other.hasPreviousPage == hasPreviousPage;
  }

  @override
  int get hashCode {
    return messages.hashCode ^
        currentPage.hashCode ^
        totalPages.hashCode ^
        totalMessages.hashCode ^
        hasNextPage.hashCode ^
        hasPreviousPage.hashCode;
  }
}
