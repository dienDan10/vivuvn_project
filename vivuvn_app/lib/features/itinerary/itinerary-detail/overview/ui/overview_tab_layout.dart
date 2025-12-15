import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../detail/controller/itinerary_detail_controller.dart';
import '../../schedule/controller/automically_generate_by_ai_controller.dart';
import '../controller/favourite_places_controller.dart';
import '../controller/hotels_controller.dart';
import '../controller/restaurants_controller.dart';
import 'widgets/ai_generation_warnings_modal.dart';
import 'widgets/favourite_place/place_list_item.dart';
import 'widgets/groupSize/group_size_card.dart';
import 'widgets/hotel/hotel_list_item.dart';
import 'widgets/restaurant/restaurant_list_item.dart';
import 'widgets/section_divider.dart';
import 'widgets/transportation_card.dart';

class OverviewTabLayout extends ConsumerStatefulWidget {
  const OverviewTabLayout({super.key});

  @override
  ConsumerState<OverviewTabLayout> createState() => _OverviewTabLayoutState();
}

class _OverviewTabLayoutState extends ConsumerState<OverviewTabLayout>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _hotelsExpanded = false;
  bool _restaurantsExpanded = false;
  bool _placesExpanded = false;

  bool _itineraryListenerRegistered = false;
  bool _initialDataLoaded = false;
  bool _warningsModalShown = false;

  late AnimationController _hotelsAnimationController;
  late AnimationController _restaurantsAnimationController;
  late AnimationController _placesAnimationController;

  late Animation<double> _hotelsIconRotation;
  late Animation<double> _restaurantsIconRotation;
  late Animation<double> _placesIconRotation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

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
    super.build(context);

    // Use .select() to watch only specific parts of state
    final places = ref.watch(
      favouritePlacesControllerProvider.select((final s) => s.places),
    );
    final placesLoading = ref.watch(
      favouritePlacesControllerProvider.select((final s) => s.isLoading),
    );
    final placesError = ref.watch(
      favouritePlacesControllerProvider.select((final s) => s.error),
    );

    final hotelsCount = ref.watch(
      hotelsControllerProvider.select((final s) => s.hotels.length),
    );
    final restaurantsCount = ref.watch(
      restaurantsControllerProvider.select((final s) => s.restaurants.length),
    );

    // Load data on first render if itineraryId exists
    if (!_itineraryListenerRegistered) {
      final currentId = ref.read(itineraryDetailControllerProvider).itineraryId;

      if (currentId != null && !_initialDataLoaded) {
        _initialDataLoaded = true;

        final needsPlacesLoad = places.isEmpty && !placesLoading;
        final needsHotelsLoad = hotelsCount == 0 &&
            !ref.read(hotelsControllerProvider).isLoading;
        final needsRestaurantsLoad = restaurantsCount == 0 &&
            !ref.read(restaurantsControllerProvider).isLoading;

        if (needsPlacesLoad || needsHotelsLoad || needsRestaurantsLoad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              if (needsPlacesLoad) {
                ref
                    .read(favouritePlacesControllerProvider.notifier)
                    .loadFavouritePlaces(currentId);
              }
              if (needsHotelsLoad) {
                ref.read(hotelsControllerProvider.notifier).loadHotels(currentId);
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

      ref.listen(itineraryDetailControllerProvider, (final previous, final next) {
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
            // Reset warnings modal flag when itinerary changes
            _warningsModalShown = false;
          }
        } catch (_) {
          // ignore
        }
      });
      _itineraryListenerRegistered = true;
    }

    // Listen to warnings and show modal if there are any
    ref.listen(aiGenerationWarningsProvider, (final previous, final next) {
      // Only show modal if:
      // 1. There are warnings
      // 2. Warnings changed (new warnings appeared)
      // 3. Modal hasn't been shown yet for these warnings
      // 4. Widget is still mounted
      if (next.isNotEmpty && 
          previous != next && 
          !_warningsModalShown && 
          mounted) {
        _warningsModalShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && next.isNotEmpty) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (final context) => const AiGenerationWarningsModal(),
            ).then((_) {
              // Reset flag when modal is closed
              _warningsModalShown = false;
            });
          }
        });
      } else if (next.isEmpty) {
        // Reset flag when warnings are cleared
        _warningsModalShown = false;
      }
    });

    // Show loading on first load
    if (placesLoading && places.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error if present
    if (placesError != null && places.isEmpty) {
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
              placesError,
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

    const extraItemsCount = 6;
    final totalItemCount = places.length + extraItemsCount;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(),
          const GroupSizeCard(),
          const TransportationCard(),

          // Hotels section
          ...List.generate(
            hotelsCount + 3,
            (final index) => HotelListItem(
              index: index,
              isExpanded: _hotelsExpanded,
              iconRotationAnimation: _hotelsIconRotation,
              onToggle: toggleHotels,
            ),
          ),
          const SectionDivider(),

          // Restaurants section
          ...List.generate(
            restaurantsCount + 3,
            (final index) => RestaurantListItem(
              index: index,
              isExpanded: _restaurantsExpanded,
              iconRotationAnimation: _restaurantsIconRotation,
              onToggle: toggleRestaurants,
            ),
          ),
          const SectionDivider(),

          // Places section
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
    );
  }
}
