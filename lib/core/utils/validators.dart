/// Utility validators for AppleHaat form validation
abstract final class Validators {
  static final RegExp _mobileRegex = RegExp(r'^[6-9]\d{9}$');
  static final RegExp _otpRegex = RegExp(r'^\d{6}$');

  /// Validates a standard 10-digit Indian mobile number (Kashmir +91)
  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }
    if (!_mobileRegex.hasMatch(cleaned)) {
      return 'Enter a valid Indian mobile number starting with 6, 7, 8 or 9';
    }
    return null;
  }

  /// Validates a 6-digit numeric OTP code
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the 6-digit OTP';
    }
    final cleaned = value.trim();
    if (cleaned.length != 6 || !_otpRegex.hasMatch(cleaned)) {
      return 'OTP must be 6 digits';
    }
    return null;
  }

  /// Validates required text (e.g. Full Name, Mandi)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }
}
