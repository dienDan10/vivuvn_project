import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/hotels_controller.dart';
import '../../data/dto/hotel_item_response.dart';

class HotelCard extends ConsumerStatefulWidget {
  const HotelCard({required this.hotel, this.index, super.key});

  final HotelItemResponse hotel;
  final int? index;

  @override
  ConsumerState<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends ConsumerState<HotelCard> {
  bool _expanded = false;
  late final TextEditingController _costController;
  late final TextEditingController _noteController;
  late final FocusNode _costFocusNode;
  late final FocusNode _noteFocusNode;
  bool _savingCost = false;
  bool _savingNote = false;
  bool _savingDates = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  void initState() {
    super.initState();
    _costController = TextEditingController();
    _noteController = TextEditingController();
    _costFocusNode = FocusNode();
    _noteFocusNode = FocusNode();

    _costController.text = widget.hotel.cost != null
        ? widget.hotel.cost!.toString()
        : '';
    _noteController.text = widget.hotel.note ?? '';

    _costFocusNode.addListener(() {
      if (!_costFocusNode.hasFocus) _onCostFieldUnfocused();
    });

    _noteFocusNode.addListener(() {
      if (!_noteFocusNode.hasFocus) _onNoteFieldUnfocused();
    });
  }

  @override
  void didUpdateWidget(covariant final HotelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hotel.id != widget.hotel.id ||
        oldWidget.hotel.cost != widget.hotel.cost) {
      _costController.text = widget.hotel.cost != null
          ? widget.hotel.cost!.toString()
          : '';
    }
    if (oldWidget.hotel.id != widget.hotel.id ||
        oldWidget.hotel.note != widget.hotel.note) {
      _noteController.text = widget.hotel.note ?? '';
    }
  }

  @override
  void dispose() {
    _costController.dispose();
    _noteController.dispose();
    _costFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onCostFieldUnfocused() async {
    final text = _costController.text.trim();
    if (text.isEmpty) return;
    if (mounted) FocusScope.of(context).unfocus();
    final parsed = double.tryParse(text.replaceAll(',', '.'));
    if (parsed == null) {
      if (mounted)
        GlobalToast.showErrorToast(
          context,
          message: 'Giá trị chi phí không hợp lệ',
        );
      return;
    }
    setState(() => _savingCost = true);
    final success = await ref
        .read(hotelsControllerProvider.notifier)
        .updateHotelCost(id: widget.hotel.id, cost: parsed);
    setState(() => _savingCost = false);
    if (!mounted) return;
    if (success) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Cập nhật chi phí thành công',
      );
    } else {
      GlobalToast.showErrorToast(context, message: 'Cập nhật chi phí thất bại');
    }
  }

  Future<void> _onNoteFieldUnfocused() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    if (mounted) FocusScope.of(context).unfocus();
    setState(() => _savingNote = true);
    final success = await ref
        .read(hotelsControllerProvider.notifier)
        .updateHotelNote(id: widget.hotel.id, note: text);
    setState(() => _savingNote = false);
    if (!mounted) return;
    if (success) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Cập nhật ghi chú thành công',
      );
    } else {
      GlobalToast.showErrorToast(context, message: 'Cập nhật ghi chú thất bại');
    }
  }

  DateTime _toDateOnly(final DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _pickDateRange() async {
    final currentStart = widget.hotel.checkInDate;
    final currentEnd = widget.hotel.checkOutDate;
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDayOfWeek: 1,
    );

    final result = await showCalendarDatePicker2Dialog(
      context: context,
      value: [currentStart, currentEnd],
      config: config,
      dialogSize: const Size(340, 400),
      borderRadius: BorderRadius.circular(12),
    );
    if (result == null || result.isEmpty) return;

    DateTime? newStart = result[0];
    DateTime? newEnd = (result.length > 1) ? result[1] : null;
    if (newStart != null) newStart = _toDateOnly(newStart);
    if (newEnd != null) newEnd = _toDateOnly(newEnd);
    if (newStart == null || newEnd == null) return;
    if (newEnd.isBefore(newStart)) {
      final tmp = newStart;
      newStart = newEnd;
      newEnd = tmp;
    }

    setState(() => _savingDates = true);
    final success = await ref
        .read(hotelsControllerProvider.notifier)
        .updateHotelDate(
          id: widget.hotel.id,
          checkInDate: newStart,
          checkOutDate: newEnd,
        );
    setState(() => _savingDates = false);
    if (!mounted) return;
    if (success) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Cập nhật ngày thành công',
      );
    } else {
      GlobalToast.showErrorToast(context, message: 'Cập nhật ngày thất bại');
    }
  }

  @override
  Widget build(final BuildContext context) {
    final hotel = widget.hotel;
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hotel.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Nhận: ${hotel.checkInDate != null ? dateFormatter.format(hotel.checkInDate!) : '--/--'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Trả: ${hotel.checkOutDate != null ? dateFormatter.format(hotel.checkOutDate!) : '--/--'}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_expanded)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NHẬN PHÒNG',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: _pickDateRange,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          hotel.checkInDate != null
                                              ? dateFormatter.format(
                                                  hotel.checkInDate!,
                                                )
                                              : '--/--',
                                        ),
                                      ),
                                      if (_savingDates)
                                        const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TRẢ PHÒNG',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: _pickDateRange,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          hotel.checkOutDate != null
                                              ? dateFormatter.format(
                                                  hotel.checkOutDate!,
                                                )
                                              : '--/--',
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      if (_savingDates)
                                        const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _costController,
                      focusNode: _costFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Chi phí',
                        prefixIcon: const Icon(Icons.attach_money),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        suffixIcon: _savingCost
                            ? const SizedBox(
                                width: 36,
                                height: 36,
                                child: Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                      onFieldSubmitted: (_) => _costFocusNode.unfocus(),
                    ),

                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _noteController,
                      focusNode: _noteFocusNode,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Ghi chú',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        suffixIcon: _savingNote
                            ? const SizedBox(
                                width: 36,
                                height: 36,
                                child: Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                      onEditingComplete: () => _noteFocusNode.unfocus(),
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (final context) => AlertDialog(
                                title: const Text('Xác nhận xóa'),
                                content: Text(
                                  'Bạn có chắc chắn muốn xóa "${hotel.name}" khỏi danh sách?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              await ref
                                  .read(hotelsControllerProvider.notifier)
                                  .removeHotel(hotel.id);
                              if (context.mounted)
                                GlobalToast.showSuccessToast(
                                  context,
                                  message: 'Xóa khách sạn thành công',
                                );
                            }
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
