import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../itinerary/create-itinerary/controller/create_itinerary_controller.dart';
import '../../../../itinerary/create-itinerary/models/province.dart';
import '../../../controller/search_itineraries_controller.dart';
import '../../../data/dto/itinerary_dto.dart';

class SearchItinerariesModal extends ConsumerStatefulWidget {
  const SearchItinerariesModal({super.key});

  static Future<void> show(final BuildContext context) async {
    return await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (final context) => const SearchItinerariesModal(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  ConsumerState<SearchItinerariesModal> createState() =>
      _SearchItinerariesModalState();
}

class _SearchItinerariesModalState
    extends ConsumerState<SearchItinerariesModal> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController()
      ..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final controller = ref.read(searchItinerariesControllerProvider.notifier);
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      controller.loadMore();
    }
  }

  Widget _buildItineraryTile(final ItineraryDto itinerary) {
    final theme = Theme.of(context);
    final dateRange = itinerary.formattedDateRange;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        // Allow a bit more vertical room to avoid text overflow in tighter layouts
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: SizedBox(
                width: 130,
                height: 140,
                child: Image.network(
                  itinerary.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (final context, final error, final stackTrace) =>
                          Image.asset(
                    'assets/images/images-placeholder.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itinerary.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (itinerary.startProvinceName.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.flight_takeoff,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              itinerary.startProvinceName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (itinerary.startProvinceName.isNotEmpty &&
                        itinerary.destinationProvinceName.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Icon(
                          Icons.arrow_downward,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                    if (itinerary.destinationProvinceName.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.flight_land,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              itinerary.destinationProvinceName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    Text(
                      dateRange,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(searchItinerariesControllerProvider);
    final controller = ref.read(searchItinerariesControllerProvider.notifier);
    final provinceSearch =
        ref.read(createItineraryControllerProvider.notifier);

    // keep controller text in sync with state
    if (_controller.text != state.searchText) {
      _controller.value = TextEditingValue(
        text: state.searchText,
        selection: TextSelection.collapsed(offset: state.searchText.length),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm lịch trình'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Search field
                Expanded(
                  child: TypeAheadField<Province>(
                    controller: _controller,
                    focusNode: _focusNode,
                    hideWithKeyboard: true,
                    hideOnUnfocus: true,
                    hideOnEmpty: true,
                    hideOnLoading: true,
                    hideOnSelect: true,
                    debounceDuration: const Duration(milliseconds: 400),
                    suggestionsCallback: (final searchText) {
                      if (searchText.trim().isEmpty) {
                        return Future.value(<Province>[]);
                      }
                      return provinceSearch.searchProvince(searchText);
                    },
                    itemBuilder: (final context, final province) {
                      return ListTile(
                        title: Text(province.name),
                      );
                    },
                    onSelected: (final province) {
                      controller.selectProvince(province);
                      _focusNode.unfocus();
                      _focusNode.canRequestFocus = false;
                      FocusScope.of(context).unfocus();
                      // Defensive unfocus to ensure keyboard closes
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    emptyBuilder: (final context) => const SizedBox.shrink(),
                    builder:
                        (final context, final textController, final focusNode) {
                      return TextField(
                        controller: textController,
                        focusNode: focusNode,
                        // Chỉ autofocus khi chưa chọn tỉnh/thành
                        autofocus: state.selectedProvince == null,
                        decoration: InputDecoration(
                          hintText: 'Nhập tỉnh/thành của lịch trình...',
                          suffixIcon: state.searchText.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    textController.clear();
                                    controller.clearSearch();
                                    _focusNode.canRequestFocus = true;
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: controller.updateSearchText,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.selectedProvince == null
                        ? null
                        : () {
                            controller.searchByProvince();
                            FocusScope.of(context).unfocus();
                            _focusNode.canRequestFocus = false;
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(52, 52),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const SizedBox(height: 16),

            // Results list with pagination
            Expanded(
              child: Builder(
                builder: (final context) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.itineraries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            !state.hasSearched
                                ? 'Chọn tỉnh/thành để tìm kiếm lịch trình'
                                : 'Chưa có lịch trình nào cho tỉnh/thành này',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.searchByProvince();
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: state.itineraries.length +
                          (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (final context, final index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (final context, final index) {
                        if (index >= state.itineraries.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final itinerary = state.itineraries[index];
                        return _buildItineraryTile(itinerary);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
