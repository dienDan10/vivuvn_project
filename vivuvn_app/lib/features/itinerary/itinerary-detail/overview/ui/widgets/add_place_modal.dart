import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_place_modal_header.dart';
import 'add_place_search_field.dart';

class AddPlaceModal extends ConsumerStatefulWidget {
  const AddPlaceModal({super.key});

  @override
  ConsumerState<AddPlaceModal> createState() => _AddPlaceModalState();
}

class _AddPlaceModalState extends ConsumerState<AddPlaceModal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (final notification) {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (final context, final scrollController) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddPlaceModalHeader(),
                const SizedBox(height: 24),
                AddPlaceSearchField(controller: _searchController),
                const SizedBox(height: 16),
                Expanded(
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (final context, final value, final child) {
                      if (value.text.isEmpty) {
                        // Empty state khi chưa search
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nhập tên địa điểm để tìm kiếm',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // Khi đang search, TypeAheadField sẽ show suggestions
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
