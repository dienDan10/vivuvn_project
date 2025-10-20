import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/animations/page_transition.dart';
import '../../../controller/create_itinerary_controller.dart';
import '../../../models/province.dart';
import 'add_province_btn.dart';
import 'select_province.dart';

class SelectDestinationLocation extends ConsumerStatefulWidget {
  const SelectDestinationLocation({super.key});

  @override
  ConsumerState<SelectDestinationLocation> createState() =>
      _SelectDestinationLocationState();
}

class _SelectDestinationLocationState
    extends ConsumerState<SelectDestinationLocation> {
  void _handleSelectProvince(final Function(Province) onSelected) {
    Navigator.of(context).push(
      PageTransition.slideInFromBottom(SelectProvince(onSelected: onSelected)),
    );
  }

  void _selectEndLocation(final Province province) {
    ref
        .read(createItineraryControllerProvider.notifier)
        .setDestinationProvince(province);
  }

  @override
  Widget build(final BuildContext context) {
    final destinationProvince = ref.watch(
      createItineraryControllerProvider.select(
        (final state) => state.destinationProvince,
      ),
    );

    return AddProvinceButton(
      icon: Icons.flight_land,
      text: destinationProvince?.name ?? 'Bạn muốn tới đâu ?',
      onClick: () => _handleSelectProvince(_selectEndLocation),
    );
  }
}
