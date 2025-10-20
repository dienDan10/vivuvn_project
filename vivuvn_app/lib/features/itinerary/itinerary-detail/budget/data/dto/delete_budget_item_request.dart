class DeleteBudgetItemRequest {
  DeleteBudgetItemRequest({required this.itemId, this.itineraryId});

  final int? itineraryId;
  final int itemId;

  Map<String, dynamic> toJson() => {
    'itineraryId': itineraryId,
    'itemId': itemId,
  };
}
