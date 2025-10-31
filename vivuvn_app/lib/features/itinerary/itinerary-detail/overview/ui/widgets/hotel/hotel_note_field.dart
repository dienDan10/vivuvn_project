import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/toast/global_toast.dart';
import '../../../controller/hotels_controller.dart';
import '../../../state/hotels_state.dart';

class HotelNoteField extends ConsumerStatefulWidget {
  const HotelNoteField({
    required this.hotelId,
    required this.initialNote,
    super.key,
  });

  final String hotelId;
  final String? initialNote;

  @override
  ConsumerState<HotelNoteField> createState() => _HotelNoteFieldState();
}

class _HotelNoteFieldState extends ConsumerState<HotelNoteField> {
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
  void didUpdateWidget(final HotelNoteField oldWidget) {
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
        .read(hotelsControllerProvider.notifier)
        .updateHotelNote(id: widget.hotelId, note: text);

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
  Widget build(final BuildContext context) {
    final isSaving = ref.watch(
      hotelsControllerProvider.select(
        (final state) => state.isSaving(widget.hotelId, HotelSavingType.note),
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
