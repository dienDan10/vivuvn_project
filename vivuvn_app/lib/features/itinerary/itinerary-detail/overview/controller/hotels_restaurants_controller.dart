import 'package:flutter_riverpod/flutter_riverpod.dart';

final hotelsRestaurantsControllerProvider =
    AutoDisposeNotifierProvider<
      HotelsRestaurantsController,
      HotelsRestaurantsState
    >(() => HotelsRestaurantsController());

class HotelsRestaurantsController
    extends AutoDisposeNotifier<HotelsRestaurantsState> {
  int _counter = 0;

  @override
  HotelsRestaurantsState build() {
    // Generate fake data
    final now = DateTime.now();
    final hotels = List.generate(
      3,
      (final index) => HotelItem(
        id: _generateId(),
        name: 'Khách sạn ${index + 1}',
        address: 'Địa chỉ khách sạn ${index + 1}',
        imageUrl: 'https://picsum.photos/200/200?random=$index',
        checkInDate: now.add(Duration(days: index)),
        checkOutDate: now.add(Duration(days: index + 2)),
      ),
    );

    final restaurants = List.generate(
      4,
      (final index) => RestaurantItem(
        id: _generateId(),
        name: 'Nhà hàng ${index + 1}',
        address: 'Địa chỉ nhà hàng ${index + 1}',
        imageUrl: 'https://picsum.photos/200/200?random=${index + 10}',
        mealDate: now.add(Duration(days: index)),
      ),
    );

    return HotelsRestaurantsState(hotels: hotels, restaurants: restaurants);
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}_${_counter++}';

  // Hotels methods
  void addHotel(
    final String name,
    final String address,
    final DateTime? checkInDate,
    final DateTime? checkOutDate, {
    final String? imageUrl,
  }) {
    final newHotel = HotelItem(
      id: _generateId(),
      name: name,
      address: address,
      imageUrl: imageUrl,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
    );
    state = state.copyWith(hotels: [...state.hotels, newHotel]);
  }

  void updateHotel(
    final String id,
    final String name,
    final String address,
    final DateTime? checkInDate,
    final DateTime? checkOutDate, {
    final String? imageUrl,
  }) {
    final updatedHotels = state.hotels
        .map(
          (final h) => h.id == id
              ? h.copyWith(
                  name: name,
                  address: address,
                  imageUrl: imageUrl,
                  checkInDate: checkInDate,
                  checkOutDate: checkOutDate,
                )
              : h,
        )
        .toList();
    state = state.copyWith(hotels: updatedHotels);
  }

  void removeHotel(final String id) {
    final updatedHotels = state.hotels.where((final h) => h.id != id).toList();
    state = state.copyWith(hotels: updatedHotels);
  }

  // Restaurants methods
  void addRestaurant(
    final String name,
    final String address,
    final DateTime? mealDate, {
    final String? imageUrl,
  }) {
    final newRestaurant = RestaurantItem(
      id: _generateId(),
      name: name,
      address: address,
      imageUrl: imageUrl,
      mealDate: mealDate,
    );
    state = state.copyWith(restaurants: [...state.restaurants, newRestaurant]);
  }

  void updateRestaurant(
    final String id,
    final String name,
    final String address,
    final DateTime? mealDate, {
    final String? imageUrl,
  }) {
    final updatedRestaurants = state.restaurants
        .map(
          (final r) => r.id == id
              ? r.copyWith(
                  name: name,
                  address: address,
                  imageUrl: imageUrl,
                  mealDate: mealDate,
                )
              : r,
        )
        .toList();
    state = state.copyWith(restaurants: updatedRestaurants);
  }

  void removeRestaurant(final String id) {
    final updatedRestaurants = state.restaurants
        .where((final r) => r.id != id)
        .toList();
    state = state.copyWith(restaurants: updatedRestaurants);
  }
}

class HotelsRestaurantsState {
  final List<HotelItem> hotels;
  final List<RestaurantItem> restaurants;

  HotelsRestaurantsState({required this.hotels, required this.restaurants});

  HotelsRestaurantsState copyWith({
    final List<HotelItem>? hotels,
    final List<RestaurantItem>? restaurants,
  }) {
    return HotelsRestaurantsState(
      hotels: hotels ?? this.hotels,
      restaurants: restaurants ?? this.restaurants,
    );
  }
}

class HotelItem {
  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  HotelItem({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.checkInDate,
    this.checkOutDate,
  });

  HotelItem copyWith({
    final String? id,
    final String? name,
    final String? address,
    final String? imageUrl,
    final DateTime? checkInDate,
    final DateTime? checkOutDate,
  }) {
    return HotelItem(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
    );
  }
}

class RestaurantItem {
  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final DateTime? mealDate;

  RestaurantItem({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.mealDate,
  });

  RestaurantItem copyWith({
    final String? id,
    final String? name,
    final String? address,
    final String? imageUrl,
    final DateTime? mealDate,
  }) {
    return RestaurantItem(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      mealDate: mealDate ?? this.mealDate,
    );
  }
}
