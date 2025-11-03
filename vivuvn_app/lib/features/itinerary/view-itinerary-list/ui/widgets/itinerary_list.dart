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
  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(itineraryControllerProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }

    final items = state.itineraries.where((final it) {
      if (widget.isOwner == null) return true;
      return it.isOwner == widget.isOwner;
    }).toList();

    if (items.isEmpty) {
      if (widget.isOwner == false) {
        return const EmptyItinerary(
          title: 'Bạn chưa tham gia chuyến đi nào',
          description:
              'Hãy tìm kiếm và kết nối với bạn bè để tham gia những chuyến đi thú vị nhé!',
          icon: Icons.group_outlined,
        );
      }
      return const EmptyItinerary();
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (final ctx, final index) {
        return ItineraryListItem(itinerary: items[index]);
      },
    );
  }
}
