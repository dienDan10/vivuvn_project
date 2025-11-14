import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/helper/number_format_helper.dart';
import '../../../../../../../common/toast/global_toast.dart';
import '../../../controller/hotels_controller.dart';
import '../../../state/hotels_state.dart';

class HotelCostField extends ConsumerStatefulWidget {
  const HotelCostField({
    required this.hotelId,
    required this.initialCost,
    this.isOwner = true,
    super.key,
  });

  final String hotelId;
  final double? initialCost;
  final bool isOwner;

  @override
  ConsumerState<HotelCostField> createState() => _HotelCostFieldState();
}

class _HotelCostFieldState extends ConsumerState<HotelCostField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialCost != null
          ? formatWithThousandsFromNum(widget.initialCost!)
          : '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(final HotelCostField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCost != widget.initialCost) {
      _controller.text = widget.initialCost != null
          ? formatWithThousandsFromNum(widget.initialCost!)
          : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _saveCost();
    }
  }

  Future<void> _saveCost() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (mounted) FocusScope.of(context).unfocus();

    final cleaned = text.replaceAll(',', '');
    final parsed = double.tryParse(cleaned);
    if (parsed == null) {
      if (mounted) {
        GlobalToast.showErrorToast(
          context,
          message: 'Giá trị chi phí không hợp lệ',
        );
      }
      return;
    }

    final success = await ref
        .read(hotelsControllerProvider.notifier)
        .updateHotelCost(id: widget.hotelId, cost: parsed);

    if (!mounted) return;
    if (!success) {
      GlobalToast.showErrorToast(context, message: 'Cập nhật chi phí thất bại');
    }
  }

  @override
  Widget build(final BuildContext context) {
    final isSaving = ref.watch(
      hotelsControllerProvider.select(
        (final state) => state.isSaving(widget.hotelId, HotelSavingType.cost),
      ),
    );

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      inputFormatters: widget.isOwner
          ? [ThousandsSeparatorInputFormatter()]
          : null,
      enabled: widget.isOwner,
      readOnly: !widget.isOwner,
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
        suffixIcon: isSaving
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
      onFieldSubmitted: (_) => _focusNode.unfocus(),
      onTapOutside: (_) => _focusNode.unfocus(),
    );
  }
}
