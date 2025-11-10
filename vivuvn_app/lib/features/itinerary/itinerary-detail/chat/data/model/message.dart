import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  final int id;
  final int memberId;
  final String email;
  final String username;
  final String? photo;
  final String message;
  final DateTime createdAt;
  final bool isOwnMessage;

  Message({
    required this.id,
    required this.memberId,
    required this.email,
    required this.username,
    this.photo,
    required this.message,
    required this.createdAt,
    required this.isOwnMessage,
  });

  Message copyWith({
    final int? id,
    final int? memberId,
    final String? email,
    final String? username,
    final String? photo,
    final String? message,
    final DateTime? createdAt,
    final bool? isOwnMessage,
  }) {
    return Message(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      email: email ?? this.email,
      username: username ?? this.username,
      photo: photo ?? this.photo,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isOwnMessage: isOwnMessage ?? this.isOwnMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'memberId': memberId,
      'email': email,
      'username': username,
      'photo': photo,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isOwnMessage': isOwnMessage,
    };
  }

  factory Message.fromMap(final Map<String, dynamic> map) {
    return Message(
      id: map['id'] as int,
      memberId: map['memberId'] as int,
      email: map['email'] as String,
      username: map['username'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
      message: map['message'] as String,
      createdAt: DateTime.parse('${map['createdAt'] as String}Z').toLocal(),
      isOwnMessage: map['isOwnMessage'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(final String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, memberId: $memberId, email: $email, username: $username, photo: $photo, message: $message, createdAt: $createdAt, isOwnMessage: $isOwnMessage)';
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.id == id &&
        other.memberId == memberId &&
        other.email == email &&
        other.username == username &&
        other.photo == photo &&
        other.message == message &&
        other.createdAt == createdAt &&
        other.isOwnMessage == isOwnMessage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        memberId.hashCode ^
        email.hashCode ^
        username.hashCode ^
        photo.hashCode ^
        message.hashCode ^
        createdAt.hashCode ^
        isOwnMessage.hashCode;
  }
}
