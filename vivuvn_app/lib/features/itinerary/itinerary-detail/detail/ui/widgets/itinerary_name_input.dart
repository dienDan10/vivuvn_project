import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/toast/global_toast.dart';
import '../../controller/itinerary_detail_controller.dart';

class ItineraryNameInput extends ConsumerStatefulWidget {
  const ItineraryNameInput({super.key});

  @override
  ConsumerState<ItineraryNameInput> createState() => _ItineraryNameInputState();
}

class _ItineraryNameInputState extends ConsumerState<ItineraryNameInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref
        .read(itineraryDetailControllerProvider.notifier)
        .saveName(context);
  }

  double _calculateFontSize(final String text) {
    if (text.length <= 20) return 26;
    if (text.length <= 35) return 22;
    return 18;
  }

  @override
  Widget build(final BuildContext context) {
    final nameDraft = ref.watch(
      itineraryDetailControllerProvider.select((final s) => s.nameDraft),
    );
    final currentName = ref.watch(
      itineraryDetailControllerProvider.select((final s) => s.itinerary?.name),
    );
    final desired = nameDraft ?? currentName ?? '';
    if (_controller.text != desired) {
      _controller.text = desired;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    final fontSize = _calculateFontSize(_controller.text);

    return Focus(
      onFocusChange: (final hasFocus) {
        if (!hasFocus) _save();
      },
      child: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 50,
        maxLines: 2,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        decoration: const InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        cursorColor: Colors.white,
        textInputAction: TextInputAction.done,
        onChanged: (final v) {
          if (v.length >= 50) {
            GlobalToast.showErrorToast(
              context,
              message: 'Tên lịch trình đã đạt giới hạn 50 ký tự',
            );
          }
          ref
              .read(itineraryDetailControllerProvider.notifier)
              .updateNameDraft(v);
        },
        onSubmitted: (_) => _save(),
        onEditingComplete: _save,
        onTapOutside: (final _) {
          FocusScope.of(context).unfocus();
          _save();
        },
      ),
    );
  }
}
