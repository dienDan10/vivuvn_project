import '../../itinerary/itinerary-detail/member/data/model/member.dart';
import '../../itinerary/itinerary-detail/overview/data/dto/hotel_item_response.dart';
import '../../itinerary/itinerary-detail/overview/data/dto/restaurant_item_response.dart';
import '../../itinerary/itinerary-detail/schedule/model/itinerary_day.dart';
import '../../itinerary/view-itinerary-list/models/itinerary.dart';

class PublicItineraryState {
  final Itinerary? itinerary;
  final List<ItineraryDay> days;
  final List<Member> members;
  final List<RestaurantItemResponse> restaurants;
  final List<HotelItemResponse> hotels;
  final bool isLoading;
  final bool isJoining;
  final bool isCopying;
  final String? error;
  final int selectedDayIndex;

  PublicItineraryState({
    this.itinerary,
    this.days = const [],
    this.members = const [],
    this.restaurants = const [],
    this.hotels = const [],
    this.isLoading = false,
    this.isJoining = false,
    this.isCopying = false,
    this.error,
    this.selectedDayIndex = 0,
  });

  PublicItineraryState copyWith({
    final Itinerary? itinerary,
    final List<ItineraryDay>? days,
    final List<Member>? members,
    final List<RestaurantItemResponse>? restaurants,
    final List<HotelItemResponse>? hotels,
    final bool? isLoading,
    final bool? isJoining,
    final bool? isCopying,
    final String? error,
    final int? selectedDayIndex,
  }) {
    return PublicItineraryState(
      itinerary: itinerary ?? this.itinerary,
      days: days ?? this.days,
      members: members ?? this.members,
      restaurants: restaurants ?? this.restaurants,
      hotels: hotels ?? this.hotels,
      isLoading: isLoading ?? this.isLoading,
      isJoining: isJoining ?? this.isJoining,
      isCopying: isCopying ?? this.isCopying,
      error: error,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
    );
  }
}

