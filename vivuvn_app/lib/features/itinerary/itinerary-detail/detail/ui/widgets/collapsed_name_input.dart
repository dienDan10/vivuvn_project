import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/itinerary_detail_controller.dart';

class CollapsedNameInput extends ConsumerStatefulWidget {
  const CollapsedNameInput({super.key});

  @override
  ConsumerState<CollapsedNameInput> createState() => _CollapsedNameInputState();
}

class _CollapsedNameInputState extends ConsumerState<CollapsedNameInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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

    // Auto focus when editing starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
    });

    final theme = Theme.of(context);
    
    return Focus(
      onFocusChange: (final hasFocus) {
        if (!hasFocus) _save();
      },
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        maxLength: 60,
        style: TextStyle(
          color: theme.colorScheme.onPrimaryContainer,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        cursorColor: theme.colorScheme.onPrimaryContainer,
        textInputAction: TextInputAction.done,
        onChanged: (final v) => ref
            .read(itineraryDetailControllerProvider.notifier)
            .updateNameDraft(v),
        onSubmitted: (_) => _save(),
        onEditingComplete: _save,
        onTapOutside: (final _) {
          _focusNode.unfocus();
          _save();
        },
      ),
    );
  }
}

