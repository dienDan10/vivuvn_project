import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/helper/number_format_helper.dart';
import '../../../../../../../common/toast/global_toast.dart';
import '../../../controller/restaurants_controller.dart';
import '../../../state/restaurants_state.dart';

class RestaurantCostField extends ConsumerStatefulWidget {
  const RestaurantCostField({
    required this.restaurantId,
    required this.initialCost,
    this.isOwner = true,
    super.key,
  });

  final String restaurantId;
  final double? initialCost;
  final bool isOwner;

  @override
  ConsumerState<RestaurantCostField> createState() =>
      _RestaurantCostFieldState();
}

class _RestaurantCostFieldState extends ConsumerState<RestaurantCostField> {
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
  void didUpdateWidget(final RestaurantCostField oldWidget) {
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
        .read(restaurantsControllerProvider.notifier)
        .updateRestaurantCost(id: widget.restaurantId, cost: parsed);

    if (!mounted) return;
    if (!success) {
      GlobalToast.showErrorToast(context, message: 'Cập nhật chi phí thất bại');
    }
  }

  @override
  Widget build(final BuildContext context) {
    final isSaving = ref.watch(
      restaurantsControllerProvider.select(
        (final state) => state.isSaving(widget.restaurantId, RestaurantSavingType.cost),
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
