// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../model/message.dart';

class ChatUpdate {
  final List<Message> newMessages;
  final List<int> deletedMessageIds;

  ChatUpdate({required this.newMessages, required this.deletedMessageIds});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'newMessages': newMessages.map((final x) => x.toMap()).toList(),
      'deletedMessageIds': deletedMessageIds,
    };
  }

  factory ChatUpdate.fromMap(final Map<String, dynamic> map) {
    return ChatUpdate(
      newMessages: List<Message>.from(
        (map['newMessages'] as List<dynamic>).map<Message>(
          (final x) => Message.fromMap(x as Map<String, dynamic>),
        ),
      ),
      deletedMessageIds: List<int>.from(
        (map['deletedMessageIds'] as List<dynamic>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUpdate.fromJson(final String source) =>
      ChatUpdate.fromMap(json.decode(source) as Map<String, dynamic>);

  bool get hasUpdates => newMessages.isNotEmpty || deletedMessageIds.isNotEmpty;
}
