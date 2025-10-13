class Validator {
  // private constructor to prevent instantiation
  Validator._();

  static String? validateEmail(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    // Simple email regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  static String? notEmpty(final String? value, {final String fieldName = ''}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName must not be empty';
    }
    return null;
  }

  static String? money(
    final String? value, {
    final String fieldName = 'Số tiền',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName must not be empty';
    }
    final amount = double.tryParse(value.replaceAll(',', '').trim());
    if (amount == null || amount <= 0) {
      return '$fieldName is not valid';
    }
    return null;
  }
}
