class DeleteFavoritePlaceRequest {
  final int? itineraryId;
  final int locationId;

  DeleteFavoritePlaceRequest({required this.locationId, this.itineraryId});

  Map<String, dynamic> toJson() {
    return {'itineraryId': itineraryId, 'locationId': locationId};
  }
}
