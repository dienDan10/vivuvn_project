import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationPayload {
  final String? itineraryId;
  final String? type;
  NotificationPayload({this.itineraryId, this.type});

  NotificationPayload copyWith({
    final String? itineraryId,
    final String? type,
  }) {
    return NotificationPayload(
      itineraryId: itineraryId ?? this.itineraryId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'itineraryId': itineraryId, 'type': type};
  }

  factory NotificationPayload.fromMap(final Map<String, dynamic> map) {
    return NotificationPayload(
      itineraryId: map['itineraryId'] != null
          ? map['itineraryId'] as String
          : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationPayload.fromJson(final String source) =>
      NotificationPayload.fromMap(json.decode(source) as Map<String, dynamic>);
}
