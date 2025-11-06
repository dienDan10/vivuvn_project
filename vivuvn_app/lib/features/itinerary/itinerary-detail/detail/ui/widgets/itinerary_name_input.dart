import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    await ref.read(itineraryDetailControllerProvider.notifier).saveName(context);
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

    return Focus(
      onFocusChange: (final hasFocus) {
        if (!hasFocus) _save();
      },
      child: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 60,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          isDense: true,
        ),
        cursorColor: Colors.white,
        textInputAction: TextInputAction.done,
        onChanged: (final v) => ref
            .read(itineraryDetailControllerProvider.notifier)
            .updateNameDraft(v),
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


