import '../../model/itinerary_item.dart';

class GetItemsByDayResponse {
  final List<ItineraryItem> items;

  GetItemsByDayResponse({required this.items});

  factory GetItemsByDayResponse.fromJson(final List<dynamic> json) {
    return GetItemsByDayResponse(
      items: json.map((final e) => ItineraryItem.fromJson(e)).toList(),
    );
  }
}
