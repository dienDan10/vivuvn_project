class AddHotelRequest {
  final String googlePlaceId;
  final String checkIn; // yyyy-MM-dd
  final String checkOut; // yyyy-MM-dd

  AddHotelRequest({
    required this.googlePlaceId,
    required this.checkIn,
    required this.checkOut,
  });

  Map<String, dynamic> toJson() => {
    'googlePlaceId': googlePlaceId,
    'checkIn': checkIn,
    'checkOut': checkOut,
  };
}
