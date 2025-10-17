import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/search_provice_controller.dart';
import '../../../models/province.dart';
import 'province_autocomplete_overlay.dart';

class ProvinceSuggestionOverlay extends ConsumerWidget {
  final double width;
  final List<Province> suggestions;
  final String text;
  final LayerLink layerLink;
  final Function(Province) onSelect;

  const ProvinceSuggestionOverlay({
    super.key,
    required this.width,
    required this.suggestions,
    required this.text,
    required this.layerLink,
    required this.onSelect,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool isLoading = ref.watch(
      searchProvinceControllerProvider.select((final state) => state.isLoading),
    );

    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        link: layerLink,
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        offset: const Offset(0, 2),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          shadowColor: Colors.black.withValues(alpha: 0.2),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ProvinceAutocompleteOverlay(
                  width: width,
                  suggestions: suggestions,
                  query: text,
                  onSelect: onSelect,
                ),
        ),
      ),
    );
  }
}
