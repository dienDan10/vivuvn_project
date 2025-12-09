import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/search_itineraries_controller.dart';
import 'itinerary_result_card.dart';

class SearchItineraryResultList extends ConsumerWidget {
  final ScrollController scrollController;

  const SearchItineraryResultList({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(searchItinerariesControllerProvider);
    final controller = ref.read(searchItinerariesControllerProvider.notifier);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.itineraries.isEmpty) {
      return _EmptyState(hasSearched: state.hasSearched);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await controller.searchByProvince();
      },
      child: ListView.separated(
        controller: scrollController,
        itemCount: state.itineraries.length + (state.isLoadingMore ? 1 : 0),
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
          return ItineraryResultCard(itinerary: itinerary);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasSearched;

  const _EmptyState({required this.hasSearched});

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            hasSearched
                ? 'Chưa có lịch trình nào cho tỉnh/thành này'
                : 'Chọn tỉnh/thành để tìm kiếm lịch trình',
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
}

