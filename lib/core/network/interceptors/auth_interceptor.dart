import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';
import '../../storage/storage_keys.dart';

/// AuthInterceptor injects the saved Bearer token into outbound HTTP requests.
class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService storageService;
  final void Function()? onUnauthorized;

  AuthInterceptor({
    required this.storageService,
    this.onUnauthorized,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storageService.read(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }
    return handler.next(err);
  }
}
