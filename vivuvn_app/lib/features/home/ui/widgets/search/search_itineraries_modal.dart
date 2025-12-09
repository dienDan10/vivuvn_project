import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../itinerary/create-itinerary/controller/create_itinerary_controller.dart';
import '../../../../itinerary/create-itinerary/models/province.dart';
import '../../../controller/search_itineraries_controller.dart';
import 'widgets/search_itinerary_result_list.dart';

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

            Expanded(
              child: SearchItineraryResultList(
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
