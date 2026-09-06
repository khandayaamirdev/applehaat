/// Domain-level failure representation
sealed class Failure {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Unable to connect to AppleHaat server. Please try again later.',
    int? code,
  ]) : super(code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Network connection unavailable. Please check your internet connectivity.',
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Authentication failed. Please verify your mobile number or OTP.',
    int? code,
  ]) : super(code: code);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure(
    super.message, {
    this.errors = const {},
    super.code,
  });
}

class StorageFailure extends Failure {
  const StorageFailure([
    super.message = 'Secure storage operation failed.',
  ]);
}
