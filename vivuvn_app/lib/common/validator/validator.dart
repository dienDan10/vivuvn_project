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
}
