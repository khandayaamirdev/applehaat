import 'package:dio/dio.dart';
import '../../errors/exceptions.dart';

/// ErrorInterceptor maps raw DioException into uniform domain AppExceptions.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException appException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        appException = const NetworkException();
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        String message = 'Server error occurred.';
        Map<String, List<String>> validationErrors = {};

        if (data is Map<String, dynamic>) {
          if (data['message'] is String) {
            message = data['message'] as String;
          }
          if (data['errors'] is Map<String, dynamic>) {
            final rawErrors = data['errors'] as Map<String, dynamic>;
            validationErrors = rawErrors.map((key, value) {
              if (value is List) {
                return MapEntry(key, value.map((e) => e.toString()).toList());
              }
              return MapEntry(key, [value.toString()]);
            });
          }
        }

        if (statusCode == 401) {
          appException = UnauthorizedException(message);
        } else if (statusCode == 422) {
          appException = ValidationException(message, errors: validationErrors);
        } else {
          appException = ServerException(message, statusCode);
        }
        break;

      case DioExceptionType.cancel:
        appException = const ServerException('Request was cancelled.');
        break;

      case DioExceptionType.unknown:
      default:
        appException = ServerException(
          err.message ?? 'An unexpected network error occurred.',
        );
        break;
    }

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
      ),
    );
  }
}
