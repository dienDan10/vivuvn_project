import 'package:flutter/material.dart';

class FieldDate extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onSelected;

  const FieldDate({
    super.key,
    required this.selectedDate,
    required this.onSelected,
  });

  Future<void> _pickDate(final BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    onSelected(picked);
  }

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_month_outlined),
      title: Text(
        selectedDate == null
            ? 'Chọn ngày'
            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
      ),
      onTap: () => _pickDate(context),
    );
  }
}
