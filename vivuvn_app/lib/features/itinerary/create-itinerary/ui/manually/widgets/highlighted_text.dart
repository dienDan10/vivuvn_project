import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final Color? highlightColor;
  final FontWeight? highlightWeight;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.highlightColor,
    this.highlightWeight = FontWeight.w700,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(final BuildContext context) {
    final q = query.trim();
    if (q.isEmpty) {
      return Text(text, maxLines: maxLines, overflow: overflow);
    }

    final spans = _buildTextSpans(context, text, q);
    final defaultColor = Theme.of(context).colorScheme.onSurface;
    final baseColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? defaultColor;

    return RichText(
      text: TextSpan(
        style: TextStyle(color: baseColor),
        children: spans,
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }

  List<TextSpan> _buildTextSpans(
    final BuildContext context,
    final String text,
    final String query,
  ) {
    final lcText = text.toLowerCase();
    final lcQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lcText.indexOf(lcQuery, start);
      if (idx < 0) {
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start)));
        }
        break;
      }

      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }

      spans.add(
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: TextStyle(
            fontWeight: highlightWeight,
            color: highlightColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      );

      start = idx + query.length;
    }

    return spans;
  }
}
