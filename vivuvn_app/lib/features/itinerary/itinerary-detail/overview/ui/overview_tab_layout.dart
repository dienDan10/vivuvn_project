import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';
import '../controller/favourite_places_controller.dart';
import '../controller/hotels_controller.dart';
import '../controller/restaurants_controller.dart';
import 'widgets/group_size_card.dart';
import 'widgets/hotel_list_item.dart';
import 'widgets/place_list_item.dart';
import 'widgets/restaurant_list_item.dart';
import 'widgets/section_divider.dart';
import 'widgets/transportation_card.dart';

class OverviewTabLayout extends ConsumerStatefulWidget {
  const OverviewTabLayout({super.key});

  @override
  ConsumerState<OverviewTabLayout> createState() => _OverviewTabLayoutState();
}

class _OverviewTabLayoutState extends ConsumerState<OverviewTabLayout>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Separate expand states for each section
  bool _hotelsExpanded = false;
  bool _restaurantsExpanded = false;
  bool _placesExpanded = false;

  bool _itineraryListenerRegistered = false;
  bool _initialDataLoaded = false;

  // Separate animation controllers for each section
  late AnimationController _hotelsAnimationController;
  late AnimationController _restaurantsAnimationController;
  late AnimationController _placesAnimationController;

  late Animation<double> _hotelsIconRotation;
  late Animation<double> _restaurantsIconRotation;
  late Animation<double> _placesIconRotation;

  @override
  bool get wantKeepAlive => true; // ← Giữ state khi switch tabs

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers for each section
    _hotelsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _restaurantsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _placesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize rotation animations
    _hotelsIconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _hotelsAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _restaurantsIconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _restaurantsAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _placesIconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _placesAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _hotelsAnimationController.dispose();
    _restaurantsAnimationController.dispose();
    _placesAnimationController.dispose();
    super.dispose();
  }

  void toggleHotels() {
    setState(() {
      _hotelsExpanded = !_hotelsExpanded;
      if (_hotelsExpanded) {
        _hotelsAnimationController.forward();
      } else {
        _hotelsAnimationController.reverse();
      }
    });
  }

  void toggleRestaurants() {
    setState(() {
      _restaurantsExpanded = !_restaurantsExpanded;
      if (_restaurantsExpanded) {
        _restaurantsAnimationController.forward();
      } else {
        _restaurantsAnimationController.reverse();
      }
    });
  }

  void togglePlaces() {
    setState(() {
      _placesExpanded = !_placesExpanded;
      if (_placesExpanded) {
        _placesAnimationController.forward();
      } else {
        _placesAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context); // ← Gọi super.build để AutomaticKeepAlive hoạt động

    // Lấy danh sách places từ controller
    final favouritePlacesState = ref.watch(favouritePlacesControllerProvider);
    final places = favouritePlacesState.places;

    // Lấy danh sách hotels và restaurants từ controller để hiển thị header counts
    final hotelsState = ref.watch(hotelsControllerProvider);
    final hotels = hotelsState.hotels;

    final restaurantsState = ref.watch(restaurantsControllerProvider);
    final restaurants = restaurantsState.restaurants;

    // Register a one-time listener during build so we load lists as soon as
    // `itineraryId` becomes available. `ref.listen` must be invoked while
    // building (Consumer build), so we guard registration with a bool.
    if (!_itineraryListenerRegistered) {
      final currentId = ref.read(itineraryDetailControllerProvider).itineraryId;

      // CRITICAL FIX: Load data immediately if itineraryId exists and data is empty
      // This ensures counts show up on first render instead of showing (0)
      if (currentId != null) {
        if (!_initialDataLoaded) {
          _initialDataLoaded = true;

          // Check if data needs loading and trigger immediately
          final needsPlacesLoad =
              favouritePlacesState.places.isEmpty &&
              !favouritePlacesState.isLoading;
          final needsHotelsLoad =
              hotelsState.hotels.isEmpty && !hotelsState.isLoading;
          final needsRestaurantsLoad =
              restaurantsState.restaurants.isEmpty &&
              !restaurantsState.isLoading;

          if (needsPlacesLoad || needsHotelsLoad || needsRestaurantsLoad) {
            // Schedule load for next frame to avoid modifying state during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                if (needsPlacesLoad) {
                  ref
                      .read(favouritePlacesControllerProvider.notifier)
                      .loadFavouritePlaces(currentId);
                }
                if (needsHotelsLoad) {
                  ref
                      .read(hotelsControllerProvider.notifier)
                      .loadHotels(currentId);
                }
                if (needsRestaurantsLoad) {
                  ref
                      .read(restaurantsControllerProvider.notifier)
                      .loadRestaurants(currentId);
                }
              }
            });
          }
        }
      }

      // Also listen for future changes
      ref.listen(itineraryDetailControllerProvider, (
        final previous,
        final next,
      ) {
        try {
          final id = next.itineraryId;
          if (id != null && previous?.itineraryId != id) {
            ref
                .read(favouritePlacesControllerProvider.notifier)
                .loadFavouritePlaces(id);
            ref.read(hotelsControllerProvider.notifier).loadHotels(id);
            ref
                .read(restaurantsControllerProvider.notifier)
                .loadRestaurants(id);
          }
        } catch (_) {
          // ignore
        }
      });
      _itineraryListenerRegistered = true;
    }

    // Hiển thị loading nếu đang tải lần đầu
    if (favouritePlacesState.isLoading && places.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Hiển thị error nếu có
    if (favouritePlacesState.error != null && places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              favouritePlacesState.error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Calculate total items: group_size(1) + transportation(1) + header(1) + places(n) + spacing(1) + button(1) + bottom(1)
    const extraItemsCount = 6;
    final totalItemCount = places.length + extraItemsCount;

    return Column(
      children: [
        const SizedBox(),
        const GroupSizeCard(),
        const TransportationCard(),
        Expanded(
          child: ListView(
            children: [
              // Hotels section - render items directly without nested ListView
              ...List.generate(
                hotels.length + 3,
                (final index) => HotelListItem(
                  index: index,
                  hotels: hotels,
                  isExpanded: _hotelsExpanded,
                  iconRotationAnimation: _hotelsIconRotation,
                  onToggle: toggleHotels,
                ),
              ),
              const SectionDivider(),

              // Restaurants section - render items directly
              ...List.generate(
                restaurants.length + 3,
                (final index) => RestaurantListItem(
                  index: index,
                  restaurants: restaurants,
                  isExpanded: _restaurantsExpanded,
                  iconRotationAnimation: _restaurantsIconRotation,
                  onToggle: toggleRestaurants,
                ),
              ),
              const SectionDivider(),

              // Places section - render items directly
              ...List.generate(
                totalItemCount,
                (final index) => PlaceListItem(
                  index: index,
                  places: places,
                  isExpanded: _placesExpanded,
                  iconRotationAnimation: _placesIconRotation,
                  onToggle: togglePlaces,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
