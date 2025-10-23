import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../common/validator/validator.dart';
import '../../../../controller/automically_generate_by_ai_controller.dart';

class NoteField extends ConsumerStatefulWidget {
  const NoteField({super.key});

  @override
  ConsumerState<NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends ConsumerState<NoteField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final state = ref.read(automicallyGenerateByAiControllerProvider);
    _controller = TextEditingController(text: state.specialRequirements ?? '');
    _focusNode = FocusNode();

    _controller.addListener(() {
      ref
          .read(automicallyGenerateByAiControllerProvider.notifier)
          .setSpecialRequirements(_controller.text.trim());
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
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
      validator: Validator.validateNote,
    );
  }
}
