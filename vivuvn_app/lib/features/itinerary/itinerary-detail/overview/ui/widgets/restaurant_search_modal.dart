import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../controller/search_location_controller.dart';
import '../../modal/location.dart';
import 'empty_search_result.dart';
import 'location_suggestion_card.dart';
import 'search_error_widget.dart';
import 'search_loading_indicator.dart';

Future<Location?> showRestaurantSearchModal(final BuildContext context) async {
  return await Navigator.push<Location>(
    context,
    MaterialPageRoute(
      builder: (final context) => const RestaurantSearchModal(),
      fullscreenDialog: true,
    ),
  );
}

class RestaurantSearchModal extends ConsumerStatefulWidget {
  const RestaurantSearchModal({super.key});

  @override
  ConsumerState<RestaurantSearchModal> createState() =>
      _RestaurantSearchModalState();
}

class _RestaurantSearchModalState extends ConsumerState<RestaurantSearchModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus khi mở modal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm nhà hàng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TypeAheadField<Location>(
          controller: _controller,
          focusNode: _focusNode,
          hideOnSelect: false,
          builder: (final context, final controller, final focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Nhập tên hoặc địa chỉ nhà hàng...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          ref
                              .read(searchLocationControllerProvider.notifier)
                              .clearLocations();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (final value) => setState(() {}),
            );
          },
          debounceDuration: const Duration(milliseconds: 300),
          suggestionsCallback: (final searchText) => ref
              .read(searchLocationControllerProvider.notifier)
              .searchLocation(searchText),
          itemBuilder: (final context, final suggestion) {
            return LocationSuggestionCard(
              location: suggestion,
              isAlreadyAdded: false,
            );
          },
          onSelected: (final suggestion) {
            Navigator.pop(context, suggestion);
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
