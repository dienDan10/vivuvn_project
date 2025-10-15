import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/search_provice_controller.dart';
import '../../../models/province.dart';
import 'province_autocomplete_overlay.dart';

class ProvinceAutocompleteField extends ConsumerStatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  /// Unique tag to prevent conflicts between multiple instances
  final String debounceTag;

  const ProvinceAutocompleteField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.debounceTag,
    this.controller,
    this.focusNode,
    this.validator,
  });

  @override
  ConsumerState<ProvinceAutocompleteField> createState() =>
      _ProvinceAutocompleteFieldState();
}

class _ProvinceAutocompleteFieldState
    extends ConsumerState<ProvinceAutocompleteField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  OverlayEntry? _overlayEntry;

  bool _isInternalController = false;
  bool _isInternalFocusNode = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _isInternalController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    }

    _setupListeners();
  }

  void _setupListeners() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _clearSuggestions();
      }
    });

    _controller.addListener(() {
      if (_controller.text.trim().isEmpty) {
        _clearSuggestions();
      }
    });
  }

  void _clearSuggestions() {
    ref.read(searchProvinceControllerProvider.notifier).clearProvinces();
    _removeOverlay();
  }

  void _removeOverlay() {
    if (_overlayEntry == null) return;
    try {
      _overlayEntry!.remove();
    } catch (_) {}
    _overlayEntry = null;
  }

  void _handleProvinceSelection(final Province province) {
    _controller.text = province.name;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _removeOverlay();
    _focusNode.unfocus();
  }

  void _showOverlay(final List<Province> suggestions) {
    _removeOverlay();
    if (suggestions.isEmpty) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final topLeft = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (final ctx) {
        return ProvinceAutocompleteOverlay(
          topLeft: topLeft,
          width: size.width,
          offsetY: size.height + 2,
          suggestions: suggestions,
          query: _controller.text,
          onSelect: _handleProvinceSelection,
        );
      },
    );

    final rootOverlay = Navigator.of(context).overlay ?? Overlay.of(context);
    rootOverlay.insert(_overlayEntry!);
  }

  Future<void> _handleUserInput(final String value) async {
    if (value.trim().isEmpty) return;

    await ref
        .read(searchProvinceControllerProvider.notifier)
        .searchProvince(value);
  }

  @override
  Widget build(final BuildContext context) {
    final isLoading = ref.watch(
      searchProvinceControllerProvider.select((final state) => state.isLoading),
    );
    final provinces = ref.watch(
      searchProvinceControllerProvider.select((final state) => state.provinces),
    );

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (_focusNode.hasFocus && provinces.isNotEmpty) {
        _showOverlay(provinces);
      } else {
        _removeOverlay();
      }
    });

    return Material(
      color: Colors.transparent,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        validator: widget.validator,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: Icon(widget.prefixIcon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
          suffixIcon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
        ),
        onChanged: (final value) => EasyDebounce.debounce(
          widget.debounceTag,
          const Duration(milliseconds: 500),
          () => _handleUserInput(value),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    if (_isInternalController) _controller.dispose();
    if (_isInternalFocusNode) _focusNode.dispose();
    super.dispose();
  }
}
