import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../controller/favourite_places_controller.dart';
import '../../controller/search_location_controller.dart';
import '../../modal/location.dart';
import 'empty_search_result.dart';
import 'location_suggestion_card.dart';
import 'search_error_widget.dart';
import 'search_loading_indicator.dart';
import 'search_text_field.dart';

class AddPlaceSearchField extends ConsumerStatefulWidget {
  const AddPlaceSearchField({super.key});

  @override
  ConsumerState<AddPlaceSearchField> createState() =>
      _AddPlaceSearchFieldState();
}

class _AddPlaceSearchFieldState extends ConsumerState<AddPlaceSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use .select() to watch only locationIds
    final existingLocationIds = ref.watch(
      favouritePlacesControllerProvider.select(
        (state) => state.places.map((p) => p.locationId).toSet(),
      ),
    );

    return TypeAheadField<Location>(
      controller: _controller,
      focusNode: _focusNode,
      hideOnSelect: false,
      builder: (context, controller, focusNode) {
        return SearchTextField(
          controller: controller,
          focusNode: focusNode,
          onClosePressed: () => _handleCloseButtonPressed(controller),
        );
      },
      debounceDuration: const Duration(milliseconds: 300),
      suggestionsCallback: (searchText) => ref
          .read(searchLocationControllerProvider.notifier)
          .searchLocation(searchText),
      itemBuilder: (context, suggestion) {
        final isAlreadyAdded = existingLocationIds.contains(suggestion.id);
        return LocationSuggestionCard(
          location: suggestion,
          isAlreadyAdded: isAlreadyAdded,
        );
      },
      onSelected: (suggestion) {
        final isAlreadyAdded = existingLocationIds.contains(suggestion.id);
        if (!isAlreadyAdded) {
          _handleLocationSelected(suggestion);
        }
      },
      decorationBuilder: (context, child) {
        return Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(12),
          child: child,
        );
      },
      emptyBuilder: (context) => const EmptySearchResult(),
      errorBuilder: (context, error) => SearchErrorWidget(error: error),
      loadingBuilder: (context) => const SearchLoadingIndicator(),
    );
  }

  void _handleCloseButtonPressed(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      controller.clear();
      ref.read(searchLocationControllerProvider.notifier).clearLocations();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleLocationSelected(Location suggestion) async {
    final success = await ref
        .read(favouritePlacesControllerProvider.notifier)
        .addPlaceToWishlist(suggestion.id);

    if (!mounted) return;

    if (success) {
      ref.read(searchLocationControllerProvider.notifier).clearLocations();
      Navigator.pop(context);
    }
  }
}
