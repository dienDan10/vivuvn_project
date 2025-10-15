import 'package:flutter/material.dart';

import '../../../models/province.dart';
import 'highlighted_text.dart';

class ProvinceAutocompleteOverlay extends StatelessWidget {
  final double width;
  final List<Province> suggestions;
  final String query;
  final Function(Province) onSelect;

  const ProvinceAutocompleteOverlay({
    super.key,
    required this.width,
    required this.suggestions,
    required this.query,
    required this.onSelect,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
    );
  }
}
