import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupSizeInlineEditor extends ConsumerStatefulWidget {
  const GroupSizeInlineEditor({
    required this.initialValue,
    required this.isSaving,
    required this.onChanged,
    required this.onCancel,
    required this.onSave,
    super.key,
  });

  final int? initialValue;
  final bool isSaving;
  final ValueChanged<int?> onChanged;
  final VoidCallback onCancel;
  final Future<bool> Function() onSave;

  @override
  ConsumerState<GroupSizeInlineEditor> createState() =>
      _GroupSizeInlineEditorState();
}

class _GroupSizeInlineEditorState extends ConsumerState<GroupSizeInlineEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant final GroupSizeInlineEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      final newText = widget.initialValue?.toString() ?? '';
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Số người',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (final text) {
              if (text.trim().isEmpty) {
                widget.onChanged(null);
                return;
              }
              final parsed = int.tryParse(text);
              widget.onChanged(parsed);
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: widget.isSaving ? null : widget.onCancel,
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.grey.withValues(alpha: 0.15),
            splashFactory: InkSparkle.splashFactory,
          ),
          icon: const Icon(Icons.close),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: widget.isSaving
              ? null
              : () async {
                  await widget.onSave();
                },
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.green.withValues(alpha: 0.15),
            splashFactory: InkSparkle.splashFactory,
          ),
          icon: widget.isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
        ),
      ],
    );
  }
}
