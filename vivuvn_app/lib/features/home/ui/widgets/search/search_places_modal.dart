import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';

import '../../../../itinerary/itinerary-detail/overview/controller/search_location_controller.dart';
import '../../../../itinerary/itinerary-detail/overview/models/location.dart';
import '../../../../itinerary/itinerary-detail/overview/ui/widgets/empty_search_result.dart';
import '../../../../itinerary/itinerary-detail/overview/ui/widgets/favourite_place/location_suggestion_card.dart';
import '../../../../itinerary/itinerary-detail/overview/ui/widgets/search_error_widget.dart';
import '../../../../itinerary/itinerary-detail/overview/ui/widgets/search_loading_indicator.dart';

Future<Location?> showSearchPlacesModal(final BuildContext context) async {
  return await Navigator.push<Location>(
    context,
    MaterialPageRoute(
      builder: (final context) => const SearchPlacesModal(),
      fullscreenDialog: true,
    ),
  );
}

class SearchPlacesModal extends ConsumerWidget {
  const SearchPlacesModal({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm địa điểm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TypeAheadField<Location>(
          hideOnSelect: false,
          builder: (final context, final controller, final focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Nhập tên địa điểm du lịch...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: controller.clear,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          debounceDuration: const Duration(milliseconds: 300),
          suggestionsCallback: (final searchText) {
            if (searchText.trim().isEmpty) return Future.value(<Location>[]);
            return ref
                .read(searchLocationControllerProvider.notifier)
                .searchLocation(searchText);
          },
          itemBuilder: (final context, final suggestion) {
            return LocationSuggestionCard(
              location: suggestion,
              isAlreadyAdded: false,
            );
          },
          onSelected: (final suggestion) {
            // Navigate to location detail screen
            Navigator.pop(context); // Close search modal first
            context.push('/location/${suggestion.id}');
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
        ),
      ),
    );
  }
}
