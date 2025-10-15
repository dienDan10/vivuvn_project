import 'package:flutter/material.dart';

import '../../../models/province.dart';
import 'highlighted_text.dart';

class ProvinceAutocompleteOverlay extends StatelessWidget {
  final Offset topLeft;
  final double width;
  final double offsetY;
  final List<Province> suggestions;
  final String query;
  final Function(Province) onSelect;

  const ProvinceAutocompleteOverlay({
    super.key,
    required this.topLeft,
    required this.width,
    required this.offsetY,
    required this.suggestions,
    required this.query,
    required this.onSelect,
  });

  @override
  Widget build(final BuildContext context) {
    return Positioned(
      left: topLeft.dx,
      top: topLeft.dy + offsetY,
      width: width,
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(20),
              width: 1,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (final context, final idx) {
                final province = suggestions[idx];
                return InkWell(
                  onTap: () => onSelect(province),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: HighlightedText(text: province.name, query: query),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
