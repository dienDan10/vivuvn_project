class AddItemToDayRequest {
  final int locationId;

  AddItemToDayRequest({required this.locationId});

  Map<String, dynamic> toJson() => {'locationId': locationId};
}
