class GetNewMessagesRequest {
  final int itineraryId;
  final int lastMessageId;

  GetNewMessagesRequest({
    required this.itineraryId,
    required this.lastMessageId,
  });
}
