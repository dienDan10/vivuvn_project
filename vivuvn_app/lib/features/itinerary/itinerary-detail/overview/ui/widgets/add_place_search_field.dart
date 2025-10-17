import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../controller/search_location_controller.dart';
import '../../data/dto/search_location_response.dart';
import 'empty_search_result.dart';
import 'location_suggestion_card.dart';
import 'search_error_widget.dart';
import 'search_text_field.dart';

class AddPlaceSearchField extends ConsumerStatefulWidget {
  const AddPlaceSearchField({super.key, this.controller});

  final TextEditingController? controller;

  @override
  ConsumerState<AddPlaceSearchField> createState() =>
      _AddPlaceSearchFieldState();
}

class _AddPlaceSearchFieldState extends ConsumerState<AddPlaceSearchField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // Watch locations để trigger rebuild khi có kết quả mới
    final locations = ref.watch(
      searchLocationControllerProvider.select((final state) => state.locations),
    );

    return TypeAheadField<SearchLocationResponse>(
      controller: _controller,
      focusNode: _focusNode,
      builder: (final context, final controller, final focusNode) {
        return SearchTextField(
          controller: controller,
          focusNode: focusNode,
          onClosePressed: () => _handleCloseButtonPressed(controller),
        );
      },
      debounceDuration: const Duration(milliseconds: 300),
      suggestionsCallback: (final String pattern) =>
          _searchLocationSuggestions(locations, pattern),
      itemBuilder: (final context, final suggestion) {
        return LocationSuggestionCard(location: suggestion);
      },
      onSelected: _handleLocationSelected,
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
      loadingBuilder: (final context) => const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _handleCloseButtonPressed(final TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      setState(() => controller.clear());
      ref.read(searchLocationControllerProvider.notifier).clearLocations();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<List<SearchLocationResponse>> _searchLocationSuggestions(
    final List<SearchLocationResponse> locations,
    final String value,
  ) async {
    if (value.isEmpty) return [];
    await ref
        .read(searchLocationControllerProvider.notifier)
        .searchLocation(value);
    return locations;
  }

  void _handleLocationSelected(final SearchLocationResponse suggestion) {
    ref.read(searchLocationControllerProvider.notifier).clearLocations();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã thêm "${suggestion.id}. ${suggestion.name}" vào danh sách yêu thích',
        ),
      ),
    );
  }
}
