import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/restaurants_controller.dart';
import '../../data/dto/restaurant_item_response.dart';

class RestaurantCard extends ConsumerStatefulWidget {
  const RestaurantCard({required this.restaurant, this.index, super.key});

  final RestaurantItemResponse restaurant;
  final int? index;

  @override
  ConsumerState<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends ConsumerState<RestaurantCard> {
  bool _expanded = false;
  late final TextEditingController _costController;
  late final TextEditingController _noteController;
  late final FocusNode _costFocusNode;
  late final FocusNode _noteFocusNode;
  bool _savingCost = false;
  bool _savingNote = false;
  bool _savingDate = false;
  bool _savingTime = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  void initState() {
    super.initState();
    _costController = TextEditingController();
    _noteController = TextEditingController();
    _costFocusNode = FocusNode();
    _noteFocusNode = FocusNode();

    // Prefill if RestaurantItemResponse later contains these fields
    _costController.text = widget.restaurant.cost != null
        ? widget.restaurant.cost!.toString()
        : '';
    _noteController.text = widget.restaurant.note ?? '';

    _costFocusNode.addListener(() {
      if (!_costFocusNode.hasFocus) _onCostFieldUnfocused();
    });
    _noteFocusNode.addListener(() {
      if (!_noteFocusNode.hasFocus) _onNoteFieldUnfocused();
    });
  }

  @override
  void didUpdateWidget(covariant final RestaurantCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If restaurant item changes, resync controllers (no-op until DTO has fields)
    if (oldWidget.restaurant.id != widget.restaurant.id) {
      _costController.text = widget.restaurant.cost != null
          ? widget.restaurant.cost!.toString()
          : '';
      _noteController.text = widget.restaurant.note ?? '';
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
    // Hide keyboard immediately when field loses focus
    if (mounted) FocusScope.of(context).unfocus();
    final text = _costController.text.trim();
    if (text.isEmpty) return;
    // Parse number (allow commas)
    final normalized = text.replaceAll(',', '');
    final value = double.tryParse(normalized);
    if (value == null) {
      if (mounted)
        GlobalToast.showErrorToast(
          context,
          message: 'Giá trị chi phí không hợp lệ',
        );
      return;
    }
    setState(() => _savingCost = true);
    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .updateRestaurantCost(id: widget.restaurant.id, cost: value);
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
    // Hide keyboard immediately when field loses focus
    if (mounted) FocusScope.of(context).unfocus();
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    setState(() => _savingNote = true);
    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .updateRestaurantNote(id: widget.restaurant.id, note: text);
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

  Future<void> _pickMealDate() async {
    final current = widget.restaurant.mealDate;
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
      firstDayOfWeek: 1,
    );
    final result = await showCalendarDatePicker2Dialog(
      context: context,
      value: [current],
      config: config,
      dialogSize: const Size(340, 400),
      borderRadius: BorderRadius.circular(12),
    );
    if (!mounted) return;
    if (result == null || result.isEmpty) return;
    final DateTime? pickedDate = result[0];
    if (pickedDate == null) return;

    final newDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);

    setState(() => _savingDate = true);
    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .updateRestaurantDate(id: widget.restaurant.id, date: newDate);
    setState(() => _savingDate = false);
    if (!mounted) return;
    if (success) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Cập nhật ngày ăn thành công',
      );
    } else {
      GlobalToast.showErrorToast(context, message: 'Cập nhật ngày ăn thất bại');
    }
  }

  Future<void> _pickMealTime() async {
    final current = widget.restaurant.mealDate;
    final initial = current != null
        ? TimeOfDay.fromDateTime(current)
        : const TimeOfDay(hour: 12, minute: 0);
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (!mounted) return;
    if (timeOfDay == null) return;

    final tmp = DateTime.now();
    final combined = DateTime(
      tmp.year,
      tmp.month,
      tmp.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final timeStr = DateFormat('HH:mm:ss').format(combined);

    setState(() => _savingTime = true);
    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .updateRestaurantTime(id: widget.restaurant.id, time: timeStr);
    setState(() => _savingTime = false);
    if (!mounted) return;
    if (success) {
      GlobalToast.showSuccessToast(
        context,
        message: 'Cập nhật giờ ăn thành công',
      );
    } else {
      GlobalToast.showErrorToast(context, message: 'Cập nhật giờ ăn thất bại');
    }
  }

  @override
  Widget build(final BuildContext context) {
    final restaurant = widget.restaurant;
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('HH:mm');

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
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          restaurant.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (restaurant.mealDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Ngày ăn: ${dateFormatter.format(restaurant.mealDate!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
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
                                'NGÀY',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: _pickMealDate,
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
                                          restaurant.mealDate != null
                                              ? dateFormatter.format(
                                                  restaurant.mealDate!,
                                                )
                                              : '--/--',
                                        ),
                                      ),
                                      if (_savingDate)
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
                                'GIỜ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: _pickMealTime,
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
                                          restaurant.mealDate != null
                                              ? timeFormatter.format(
                                                  restaurant.mealDate!,
                                                )
                                              : '--:--',
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      if (_savingTime)
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
                        suffixIcon: _savingCost
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : null,
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
                        suffixIcon: _savingNote
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : null,
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
                                  'Bạn có chắc chắn muốn xóa "${restaurant.name}" khỏi danh sách?',
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
                                  .read(restaurantsControllerProvider.notifier)
                                  .removeRestaurant(restaurant.id);
                              if (context.mounted) {
                                GlobalToast.showSuccessToast(
                                  context,
                                  message: 'Xóa nhà hàng thành công',
                                );
                              }
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
