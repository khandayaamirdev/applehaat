/// Base exception for AppleHaat application
sealed class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException: $message (Code: $statusCode)';
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'A server error occurred. Please try again later.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection. Please check your network and try again.',
  ]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Session expired. Please log in again.',
  ]) : super(statusCode: 401);
}

class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException(
    super.message, {
    this.errors = const {},
    super.statusCode = 422,
  });
}

class CacheException extends AppException {
  const CacheException([
    super.message = 'Failed to read/write local secure storage.',
  ]);
}
