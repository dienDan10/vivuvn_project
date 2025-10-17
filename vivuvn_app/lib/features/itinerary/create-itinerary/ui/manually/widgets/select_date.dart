import 'package:flutter/material.dart';

import 'date_range_picker.dart';

class SelectDate extends StatefulWidget {
  const SelectDate({super.key});

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  final List<DateTime?> _rangeDatePicker = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 2)),
  ];

  void _onDateSelected(final DateTime? start, final DateTime? end) {
    setState(() {
      _rangeDatePicker[0] = start;
      _rangeDatePicker[1] = end;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return DateRangePickerField(
      initialValue: _rangeDatePicker,
      onChanged: _onDateSelected,
    );
  }
}
