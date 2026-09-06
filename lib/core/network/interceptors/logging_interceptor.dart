import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// LoggingInterceptor provides clean debug output for network inspection.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[DIO] --> ${options.method.toUpperCase()} ${options.uri}');
      if (options.data != null) {
        debugPrint('[DIO] Payload: ${options.data}');
      }
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[DIO] <-- ${response.statusCode} ${response.requestOptions.uri}');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[DIO] [ERROR] ${err.response?.statusCode} ${err.requestOptions.uri}: ${err.message}');
    }
    return handler.next(err);
  }
}
