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
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Ngày chi',
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined, color: theme.colorScheme.outline),
            const SizedBox(width: 12),
            Text(
              selectedDate == null
                  ? 'Chọn ngày'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: selectedDate == null
                    ? theme.hintColor
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
