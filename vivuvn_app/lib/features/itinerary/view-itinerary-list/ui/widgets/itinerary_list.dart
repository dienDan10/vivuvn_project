import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_controller.dart';
import 'empty_itinerary.dart';
import 'itinerary_list_item.dart';

class ItineraryList extends ConsumerStatefulWidget {
  final bool? isOwner;
  const ItineraryList({super.key, this.isOwner});

  @override
  ConsumerState<ItineraryList> createState() => _ItineraryListState();
}

class _ItineraryListState extends ConsumerState<ItineraryList> {
  Future<void> _onRefresh() async {
    await ref.read(itineraryControllerProvider.notifier).fetchItineraries();
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(itineraryControllerProvider);

    final items = state.itineraries.where((final it) {
      if (widget.isOwner == null) return true;
      return it.isOwner == widget.isOwner;
    }).toList();

    // Show loading only on initial load (when list is empty)
    if (state.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error only on initial load (when list is empty)
    if (state.error != null && items.isEmpty) {
      return Center(child: Text('Error: ${state.error}'));
    }

    if (items.isEmpty) {
      if (widget.isOwner == false) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: const EmptyItinerary(
                title: 'Bạn chưa tham gia chuyến đi nào',
                description:
                    'Hãy tìm kiếm và kết nối với bạn bè để tham gia những chuyến đi thú vị nhé!',
                icon: Icons.group_outlined,
              ),
            ),
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const EmptyItinerary(),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (final ctx, final index) {
          return ItineraryListItem(itinerary: items[index]);
        },
      ),
    );
  }
}
