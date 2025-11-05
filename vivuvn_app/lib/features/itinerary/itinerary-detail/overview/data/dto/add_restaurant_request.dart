class AddRestaurantRequest {
  final String googlePlaceId;
  final String date; // yyyy-MM-dd
  final String time; // HH:mm:ss

  AddRestaurantRequest({
    required this.googlePlaceId,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'googlePlaceId': googlePlaceId,
    'date': date,
    'time': time,
  };
}
