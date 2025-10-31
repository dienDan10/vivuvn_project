import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class DateRangePickerField extends StatefulWidget {
  final List<DateTime?> initialValue; // [start, end]
  final void Function(DateTime? start, DateTime? end) onChanged;
  final String startLabel;
  final String endLabel;

  const DateRangePickerField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.startLabel = 'Start Date',
    this.endLabel = 'End Date',
  });

  @override
  State<DateRangePickerField> createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends State<DateRangePickerField> {
  late DateTime? _start = widget.initialValue.isNotEmpty
      ? widget.initialValue[0]
      : null;
  late DateTime? _end = (widget.initialValue.length > 1)
      ? widget.initialValue[1]
      : null;

  DateTime _toDateOnly(final DateTime d) => DateTime(d.year, d.month, d.day);

  String _formatDate(final DateTime? d) {
    if (d == null) return 'Pick Dates';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _openPicker() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDayOfWeek: 1,
      firstDate: todayDate,
      lastDate: todayDate.add(const Duration(days: 365)),
    );

    final result = await showCalendarDatePicker2Dialog(
      context: context,
      value: [_start, _end],
      config: config,
      dialogSize: const Size(340, 400),
      borderRadius: BorderRadius.circular(12),
      // builder default provides modal barrier dim; dialog will be centered
    );

    if (result != null && result.isNotEmpty) {
      DateTime? newStart = result[0];
      DateTime? newEnd = (result.length > 1) ? result[1] : null;

      if (newStart != null) newStart = _toDateOnly(newStart);
      if (newEnd != null) newEnd = _toDateOnly(newEnd);

      // ensure start <= end; if end < start swap
      if (newStart != null && newEnd != null && newEnd.isBefore(newStart)) {
        final tmp = newStart;
        newStart = newEnd;
        newEnd = tmp;
      }
      setState(() {
        _start = newStart;
        _end = newEnd;
      });

      widget.onChanged(_start, _end);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: _openPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.startLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(_start),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 48, width: 1, color: Colors.grey.shade200),
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.endLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(_end),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
