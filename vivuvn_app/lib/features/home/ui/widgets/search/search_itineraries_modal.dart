import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/search_itineraries_controller.dart';
import '../../../state/search_itineraries_state.dart';

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
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(searchItinerariesControllerProvider);
    final controller = ref.read(searchItinerariesControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm lịch trình'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Sort dropdown button
          PopupMenuButton<SortOrder>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sắp xếp',
            onSelected: (final value) {
              controller.updateSortOrder(value);
            },
            itemBuilder: (final context) => [
              PopupMenuItem(
                value: SortOrder.nearest,
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 12),
                    const Text('Gần với hiện tại nhất'),
                    if (state.sortOrder == SortOrder.nearest) ...[
                      const Spacer(),
                      const Icon(Icons.check, color: Colors.blue),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: SortOrder.oldest,
                child: Row(
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(width: 12),
                    const Text('Cũ nhất'),
                    if (state.sortOrder == SortOrder.oldest) ...[
                      const Spacer(),
                      const Icon(Icons.check, color: Colors.blue),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search field
            TextField(
              controller: _textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Nhập điểm đến của lịch trình...',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: state.searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _textController.clear();
                          controller.clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: controller.updateSearchText,
            ),

            const SizedBox(height: 12),

            // Current sort info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    state.sortOrder == SortOrder.nearest
                        ? Icons.access_time
                        : Icons.history,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sắp xếp: ${state.sortOrder == SortOrder.nearest ? 'Gần với hiện tại nhất' : 'Cũ nhất'}',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Results placeholder
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      state.searchText.isEmpty
                          ? 'Nhập điểm đến để tìm kiếm lịch trình'
                          : 'Đang phát triển tính năng...',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
