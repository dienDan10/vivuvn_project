import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../detail/controller/itinerary_detail_controller.dart';
import '../../controller/itinerary_schedule_controller.dart';
import 'suggested_places_content.dart';

class SuggestedPlacesTile extends ConsumerStatefulWidget {
  const SuggestedPlacesTile({super.key});

  @override
  ConsumerState<SuggestedPlacesTile> createState() => _SuggestedPlacesTileState();
}

class _SuggestedPlacesTileState extends ConsumerState<SuggestedPlacesTile> {
  int? _lastProvinceId;
  ProviderSubscription<int?>? _provinceListener;

  @override
  void initState() {
    super.initState();

    final initialProvinceId = ref.read(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.destinationProvinceId,
      ),
    );

    if (initialProvinceId != null) {
      _lastProvinceId = initialProvinceId;
    }

    _provinceListener = ref.listenManual<int?>(
      itineraryDetailControllerProvider.select(
        (final state) => state.itinerary?.destinationProvinceId,
      ),
      (final previous, final next) {
        if (next != null && next != _lastProvinceId) {
          _lastProvinceId = next;
          ref
              .read(itineraryScheduleControllerProvider.notifier)
              .fetchSuggestedLocations(provinceId: next);
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref
          .read(itineraryScheduleControllerProvider.notifier)
          .fetchSuggestedLocations(provinceId: _lastProvinceId);
    });
  }

  @override
  void dispose() {
    _provinceListener?.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return const ExpansionTile(
      title: Text('Địa điểm gợi ý'),
      children: [
        SuggestedPlacesContent(),
      ],
    );
  }
}
