import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../controller/favourite_places_controller.dart';
import '../../controller/search_location_controller.dart';
import '../../data/dto/search_location_response.dart';
import 'empty_search_result.dart';
import 'location_suggestion_card.dart';
import 'search_error_widget.dart';
import 'search_loading_indicator.dart';
import 'search_text_field.dart';

class AddPlaceSearchField extends ConsumerStatefulWidget {
  const AddPlaceSearchField({super.key, required this.itineraryId});

  final int itineraryId;

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
  Widget build(final BuildContext context) {
    // Lấy danh sách favourite places hiện tại
    final favouritePlacesState = ref.watch(favouritePlacesControllerProvider);
    final existingLocationIds = favouritePlacesState.places
        .map((final p) => p.locationId)
        .toSet();

    return TypeAheadField<SearchLocationResponse>(
      controller: _controller,
      focusNode: _focusNode,
      hideOnSelect: false,
      builder: (final context, final controller, final focusNode) {
        return SearchTextField(
          controller: controller,
          focusNode: focusNode,
          onClosePressed: () => _handleCloseButtonPressed(controller),
        );
      },
      debounceDuration: const Duration(milliseconds: 300),
      suggestionsCallback: (final searchText) => ref
          .read(searchLocationControllerProvider.notifier)
          .searchLocation(searchText),
      itemBuilder: (final context, final suggestion) {
        final isAlreadyAdded = existingLocationIds.contains(suggestion.id);
        return LocationSuggestionCard(
          location: suggestion,
          isAlreadyAdded: isAlreadyAdded,
        );
      },
      onSelected: (final suggestion) {
        // Chỉ xử lý nếu chưa được thêm
        final isAlreadyAdded = existingLocationIds.contains(suggestion.id);
        if (!isAlreadyAdded) {
          _handleLocationSelected(suggestion);
        }
      },
      decorationBuilder: (final context, final child) {
        return Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(12),
          child: child,
        );
      },
      emptyBuilder: (final context) => const EmptySearchResult(),
      errorBuilder: (final context, final error) =>
          SearchErrorWidget(error: error),
      loadingBuilder: (final context) => const SearchLoadingIndicator(),
    );
  }

  void _handleCloseButtonPressed(final TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      controller.clear();
      ref.read(searchLocationControllerProvider.notifier).clearLocations();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleLocationSelected(
    final SearchLocationResponse suggestion,
  ) async {
    ref.read(searchLocationControllerProvider.notifier).clearLocations();

    // Gọi API để thêm place vào wishlist
    await ref
        .read(favouritePlacesControllerProvider.notifier)
        .addPlaceToWishlist(widget.itineraryId, suggestion.id);

    if (!mounted) return;

    Navigator.pop(context);
  }
}
