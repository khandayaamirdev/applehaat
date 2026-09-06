/// Text and numeric formatting helpers
abstract final class Formatters {
  /// Formats 10-digit or 12-digit number to Indian readable style: +91 98765 43210
  static String formatPhoneNumber(String digits) {
    var cleaned = digits.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 12 && cleaned.startsWith('91')) {
      cleaned = cleaned.substring(2);
    }
    if (cleaned.length == 10) {
      return '+91 ${cleaned.substring(0, 5)} ${cleaned.substring(5)}';
    }
    return digits;
  }

  /// Formats seconds to mm:ss format (e.g. 00:30)
  static String formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
