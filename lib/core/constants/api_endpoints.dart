/// ApiEndpoints defines all REST API routes for the future Laravel backend.
/// Flutter communicates strictly via HTTPS REST and never directly connects to MySQL.
abstract final class ApiEndpoints {
  // Base URL (Configurable for local emulator vs production)
  static const String baseUrl = 'https://api.applehaat.com/api/v1';

  // Auth Routes
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';

  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
