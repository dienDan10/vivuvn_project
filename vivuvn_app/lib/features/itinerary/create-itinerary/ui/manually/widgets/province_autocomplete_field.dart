import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/validator/validator.dart';
import '../../../controller/search_provice_controller.dart';
import '../../../models/province.dart';
import 'province_suggestion_overlay.dart';

class ProvinceAutocompleteField extends ConsumerStatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;

  /// Unique tag to prevent conflicts between multiple instances
  final String debounceTag;

  const ProvinceAutocompleteField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.debounceTag,
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
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
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
    _overlayEntry?.remove();
  }

  void _handleProvinceSelection(final Province province) {
    _controller.text = province.name;
    _removeOverlay();
    _focusNode.unfocus();
  }

  void _showOverlay() {
    _removeOverlay();

    final suggestions = ref.read(
      searchProvinceControllerProvider.select((final state) => state.provinces),
    );

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (final ctx) {
        return ProvinceSuggestionOverlay(
          width: size.width,
          suggestions: suggestions,
          text: _controller.text,
          layerLink: _layerLink,
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

    _showOverlay();
  }

  @override
  Widget build(final BuildContext context) {
    // Listen to province suggestions changes
    // ref.listen<List<Province>>(
    //   searchProvinceControllerProvider.select((final state) => state.provinces),
    //   (final previous, final next) {
    //     if ((_focusNode.hasFocus)) {

    //     }
    //   },
    // );

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        validator: (final value) =>
            Validator.notEmpty(value, fieldName: 'This field'),
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
          // suffixIcon: isLoading
          //     ? const SizedBox(
          //         width: 20,
          //         height: 20,
          //         child: Padding(
          //           padding: EdgeInsets.all(8.0),
          //           child: CircularProgressIndicator(strokeWidth: 2),
          //         ),
          //       )
          //     : null,
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
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
