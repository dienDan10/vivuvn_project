import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/restaurants_controller.dart';
import '../../state/restaurants_state.dart';

class RestaurantNoteField extends ConsumerStatefulWidget {
  const RestaurantNoteField({
    required this.restaurantId,
    required this.initialNote,
    super.key,
  });

  final String restaurantId;
  final String? initialNote;

  @override
  ConsumerState<RestaurantNoteField> createState() =>
      _RestaurantNoteFieldState();
}

class _RestaurantNoteFieldState extends ConsumerState<RestaurantNoteField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(RestaurantNoteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialNote != widget.initialNote) {
      _controller.text = widget.initialNote ?? '';
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
      _saveNote();
    }
  }

  Future<void> _saveNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (mounted) FocusScope.of(context).unfocus();

    final success = await ref
        .read(restaurantsControllerProvider.notifier)
        .updateRestaurantNote(id: widget.restaurantId, note: text);

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

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(
      restaurantsControllerProvider.select(
        (state) => state.isSaving(widget.restaurantId, RestaurantSavingType.note),
      ),
    );

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
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
      onEditingComplete: () => _focusNode.unfocus(),
      onTapOutside: (_) => _focusNode.unfocus(),
    );
  }
}
