import 'package:flutter/services.dart';

/// Helper for formatting numeric text with thousands separators while typing.
///
/// Usage:
/// ```dart
/// final controller = TextEditingController();
/// TextField(
///   controller: controller,
///   keyboardType: TextInputType.number,
///   inputFormatters: [ThousandsSeparatorInputFormatter()],
/// )
/// ```
///
/// This will automatically insert `,` as the thousands separator when the user
/// types digits (e.g. `1000` -> `1,000`). You can adjust the [separator]
/// character if needed.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  ThousandsSeparatorInputFormatter({this.separator = ',', this.maxDigits});

  /// Character used to separate each group of three digits.
  final String separator;

  /// Optional maximum number of digits (excluding separators).
  final int? maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    final digitsOnly = _extractDigits(newValue.text);

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    final truncated = maxDigits != null && digitsOnly.length > maxDigits!
        ? digitsOnly.substring(0, maxDigits)
        : digitsOnly;

    final formatted = formatNumberWithThousands(truncated, separator: separator);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _extractDigits(final String input) {
    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (_isDigit(char)) {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  bool _isDigit(final String character) {
    if (character.isEmpty) return false;
    final code = character.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }
}

/// Format a numeric string by adding thousands separators (default: `,`).
/// Non-digit characters are ignored.
String formatNumberWithThousands(
  final String value, {
  final String separator = ',',
}) {
  final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

  if (digitsOnly.isEmpty) {
    return '';
  }

  final reversedDigits = digitsOnly.split('').reversed.toList();
  final buffer = StringBuffer();

  for (var i = 0; i < reversedDigits.length; i++) {
    if (i != 0 && i % 3 == 0) {
      buffer.write(separator);
    }
    buffer.write(reversedDigits[i]);
  }

  return buffer.toString().split('').reversed.join();
}

/// Format a numeric value (num/double/int) with thousands separators (",")
/// rounded to integer for display in money inputs.
String formatWithThousandsFromNum(final num value, {final String separator = ','}) {
  return formatNumberWithThousands(value.round().toString(), separator: separator);
}

/// Normalize and format a free-typed money string: strip existing separators
/// then re-apply thousands separators.
String formatWithThousandsFromText(final String text, {final String separator = ','}) {
  final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
  if (digitsOnly.isEmpty) return '';
  return formatNumberWithThousands(digitsOnly, separator: separator);
}

