import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/create_itinerary_controller.dart';
import 'date_range_picker.dart';

class SelectDate extends ConsumerStatefulWidget {
  const SelectDate({super.key});

  @override
  ConsumerState<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends ConsumerState<SelectDate> {
  final List<DateTime?> _rangeDatePicker = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 2)),
  ];

  void _onDateSelected(final DateTime? start, final DateTime? end) {
    setState(() {
      _rangeDatePicker[0] = start;
      _rangeDatePicker[1] = end;
    });

    ref.read(createItineraryControllerProvider.notifier).setDates(start, end);
  }

  @override
  Widget build(final BuildContext context) {
    return DateRangePickerField(
      initialValue: _rangeDatePicker,
      onChanged: _onDateSelected,
    );
  }
}
