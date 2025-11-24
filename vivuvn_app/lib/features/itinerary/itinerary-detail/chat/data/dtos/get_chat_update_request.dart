class GetChatUpdateRequest {
  final int itineraryId;
  final int lastMessageId;
  final DateTime? lastPolledAt;

  GetChatUpdateRequest({
    required this.itineraryId,
    required this.lastMessageId,
    this.lastPolledAt,
  });
}
