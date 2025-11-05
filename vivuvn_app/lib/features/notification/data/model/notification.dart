import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Notification {
  final String id;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  int? itineraryId;
  String? itineraryName;

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.itineraryId,
    this.itineraryName,
  });

  Notification copyWith({
    final String? id,
    final String? type,
    final String? title,
    final String? message,
    final bool? isRead,
    final DateTime? createdAt,
    final int? itineraryId,
    final String? itineraryName,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      itineraryId: itineraryId ?? this.itineraryId,
      itineraryName: itineraryName ?? this.itineraryName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'itineraryId': itineraryId,
      'itineraryName': itineraryName,
    };
  }

  factory Notification.fromMap(final Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      isRead: map['isRead'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      itineraryId: map['itineraryId'] != null
          ? map['itineraryId'] as int
          : null,
      itineraryName: map['itineraryName'] != null
          ? map['itineraryName'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(final String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);
}
