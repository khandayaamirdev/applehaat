/// AppConstants holds global configuration values.
/// Does not hard-code districts, tehsils or mandis as permanent application data.
abstract final class AppConstants {
  static const String appName = 'AppleHaat';
  static const String appTagline = "Kashmir's Biggest Apple Marketplace";

  // Mobile Validation & Testing
  static const int mobileLength = 10;
  static const String defaultCountryCode = '+91';
  static const int otpLength = 6;
  static const int otpResendCooldownSeconds = 30;

}
