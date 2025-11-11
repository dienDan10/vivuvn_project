class Validator {
  // private constructor to prevent instantiation
  Validator._();

  static String? validateEmail(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email không được để trống';
    }
    // Simple email regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? validatePassword(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  static String? notEmpty(final String? value, {final String fieldName = ''}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }

  static String? money(
    final String? value, {
    final String fieldName = 'Số tiền',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    // Using comma as thousands separator; keep dot as decimal
    final sanitized = value.replaceAll(',', '').trim();
    final amount = double.tryParse(sanitized);
    if (amount == null || amount <= 0) {
      return '$fieldName không hợp lệ';
    }
    return null;
  }

  // Validate budget input. currency should be either 'VND' or 'USD'.
  static String? validateBudget(
    final String? value, {
    final String currency = 'VND',
  }) {
    if (value == null || value.trim().isEmpty) return 'Xin hãy nhập ngân sách';
    final sanitized = value.replaceAll(',', '').trim();
    final amount = double.tryParse(sanitized);
    if (amount == null || amount <= 0) return 'Ngân sách phải là một số dương';
    // Optional: enforce minimum reasonable amount (e.g., 1)
    if (currency == 'USD' && amount < 1) return 'Ngân sách phải ít nhất 1 USD';
    if (currency == 'VND' && amount < 1000) {
      return 'Ngân sách phải ít nhất 1,000 VND';
    }
    return null;
  }

  // Validate group size (integer between 1 and 6)
  static String? validateGroupSize(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Xin hãy nhập số lượng nhóm';
    }
    final n = int.tryParse(value.trim());
    if (n == null) return 'Số lượng người trong đoàn phải là một số';
    if (n < 1 || n > 10) return 'Số lượng người trong đoàn phải từ 1 đến 10';
    return null;
  }

  // Simple sensitive-word filter. Returns true if text contains any prohibited word.
  static bool containsSensitiveWords(final String? text) {
    if (text == null || text.trim().isEmpty) return false;
    final lower = text.toLowerCase();
    // A short list of example sensitive words. Extend as required.
    const prohibited = [
      'sex',
      'viagra',
      'porn',
      'đồi trụy',
      'bạo lực',
      'ma túy',
      'thuốc phiện',
      'cứt',
      'đụ',
      'đĩ',
      'lồn',
      'đéo',
      'đm',
      'cc',
      'cặc',
      'buồi',
      'shit',
      'fuck',
      'địt',
      'gay',
      'lesbian',
      'điếm',
      'whore',
      'prostitute',
      'pussy',
      'dick',
      'bitch',
      'bastard',
      'asshole',
      'motherfucker',
      'cunt',
    ];
    for (final word in prohibited) {
      if (lower.contains(word)) return true;
    }
    return false;
  }

  static String? validateNote(final String? text) {
    if (text == null || text.trim().isEmpty) return null; // optional
    if (containsSensitiveWords(text)) return 'Ghi chú chứa từ cấm';
    if (text.length > 500) return 'Ghi chú quá dài (tối đa 500 ký tự)';
    return null;
  }

  // Validate money that can be zero or positive (for estimated budget)
  static String? moneyOrZero(
    final String? value, {
    final String fieldName = 'Số tiền',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    final sanitized = value.replaceAll(',', '').trim();
    final amount = double.tryParse(sanitized);
    if (amount == null || amount < 0) {
      return '$fieldName không hợp lệ';
    }
    return null;
  }
}
