import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Validator moved to controller/modal level; no import needed here
import '../../../../controller/automically_generate_by_ai_controller.dart';

class NoteField extends ConsumerStatefulWidget {
  const NoteField({super.key});

  @override
  ConsumerState<NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends ConsumerState<NoteField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Do not access inherited providers in initState. Initialization that
    // depends on providers is done in didChangeDependencies below.
  }

  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;

    final stateSpecialRequirements = ref.watch(
      automicallyGenerateByAiControllerProvider.select(
        (final state) => state.specialRequirements,
      ),
    );
    _controller = TextEditingController(text: stateSpecialRequirements ?? '');

    _controller.addListener(() {
      ref
          .read(automicallyGenerateByAiControllerProvider.notifier)
          .setSpecialRequirements(_controller.text.trim());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return TextField(
      controller: _controller,
      onTapOutside: (final event) => FocusScope.of(context).unfocus(),
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Ghi chú',
        hintText: 'vd. Ưu tiên khách sạn yên tĩnh, ăn chay, tránh đường dốc',
        helperText: 'Tùy chọn: yêu cầu đặc biệt hoặc hạn chế',
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    );
  }
}
