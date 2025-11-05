class GetMessagesRequest {
  final int itineraryId;
  final int? page;
  final int? pageSize;

  GetMessagesRequest({
    required this.itineraryId,
    this.page = 1,
    this.pageSize = 50,
  });
}
