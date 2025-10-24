import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';

class GroupSizeField extends ConsumerStatefulWidget {
  const GroupSizeField({super.key});

  @override
  ConsumerState<GroupSizeField> createState() => _GroupSizeFieldState();
}

class _GroupSizeFieldState extends ConsumerState<GroupSizeField> {
  late final TextEditingController _controller;
  bool _didInit = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    final stateGroupSize = ref.watch(
      automicallyGenerateByAiControllerProvider.select(
        (final state) => state.groupSize,
      ),
    );
    final ctrl = ref.read(automicallyGenerateByAiControllerProvider.notifier);
    _controller = TextEditingController(
      text: ctrl.formatGroupSize(stateGroupSize),
    );

    _controller.addListener(() {
      ctrl.setGroupSizeFromString(_controller.text);
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
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Số người',
        hintText: 'vd. 2 (số người tham gia chuyến đi, tối đa 10)',
        helperText: 'Nhập số người tham gia (1-10)',
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    );
  }
}
