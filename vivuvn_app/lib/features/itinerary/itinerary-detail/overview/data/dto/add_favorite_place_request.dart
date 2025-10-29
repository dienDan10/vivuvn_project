class AddFavoritePlaceRequest {
  AddFavoritePlaceRequest({
    required this.itineraryId,
    required this.locationId,
  });

  final int? itineraryId;
  final int locationId;

  Map<String, dynamic> toJson() => {
    'itineraryId': itineraryId,
    'locationId': locationId,
  };
}
