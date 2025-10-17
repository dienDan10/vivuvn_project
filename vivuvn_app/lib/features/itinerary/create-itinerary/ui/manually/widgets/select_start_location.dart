import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/animations/page_transition.dart';
import '../../../controller/create_itinerary_controller.dart';
import '../../../models/province.dart';
import 'add_province_btn.dart';
import 'select_province.dart';

class SelectStartLocation extends ConsumerStatefulWidget {
  const SelectStartLocation({super.key});

  @override
  ConsumerState<SelectStartLocation> createState() =>
      _SelectStartLocationState();
}

class _SelectStartLocationState extends ConsumerState<SelectStartLocation> {
  void _handleSelectProvince(final Function(Province) onSelected) {
    Navigator.of(context).push(
      PageTransition.slideInFromBottom(SelectProvince(onSelected: onSelected)),
    );
  }

  void _selectStartLocation(final Province province) {
    ref
        .read(createItineraryControllerProvider.notifier)
        .setStartProvince(province);
  }

  @override
  Widget build(final BuildContext context) {
    final startProvince = ref.watch(
      createItineraryControllerProvider.select(
        (final state) => state.startProvince,
      ),
    );

    return AddProvinceButton(
      icon: Icons.flight_takeoff,
      text: startProvince?.name ?? 'Chọn nơi khởi hành ?',
      onClick: () => _handleSelectProvince(_selectStartLocation),
    );
  }
}
