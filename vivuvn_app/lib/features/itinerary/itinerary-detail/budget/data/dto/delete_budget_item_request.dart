/// DTO để xóa budget item
///
/// Required:
/// - itemId: ID của budget item cần xóa
/// - itineraryId: ID của itinerary (optional nhưng nên có)
class DeleteBudgetItemRequest {
  final int itemId;
  final int? itineraryId;

  const DeleteBudgetItemRequest({required this.itemId, this.itineraryId});

  Map<String, dynamic> toJson() => {
    'itineraryId': itineraryId,
    'itemId': itemId,
  };

  @override
  String toString() =>
      'DeleteBudgetItemRequest(itemId: $itemId, itineraryId: $itineraryId)';
}
