import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../controller/hotels_controller.dart';
import '../../modal/location.dart';
import 'empty_search_result.dart';
import 'location_suggestion_card.dart';
import 'search_error_widget.dart';
import 'search_loading_indicator.dart';

Future<Location?> showHotelSearchModal(final BuildContext context) async {
  return await Navigator.push<Location>(
    context,
    MaterialPageRoute(
      builder: (final context) => const HotelSearchModal(),
      fullscreenDialog: true,
    ),
  );
}

class HotelSearchModal extends ConsumerStatefulWidget {
  const HotelSearchModal({super.key});

  @override
  ConsumerState<HotelSearchModal> createState() => _HotelSearchModalState();
}

class _HotelSearchModalState extends ConsumerState<HotelSearchModal> {
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
        title: const Text('Tìm kiếm khách sạn'),
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
                hintText: 'Nhập tên hoặc địa chỉ khách sạn...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          setState(() {});
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
          suggestionsCallback: (final searchText) {
            if (searchText.trim().isEmpty) return Future.value(<Location>[]);
            return ref
                .read(hotelsControllerProvider.notifier)
                .searchHotels(searchText);
          },
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
