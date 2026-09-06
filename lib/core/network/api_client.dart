import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_endpoints.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// ApiClient configures and exposes the Dio HTTP client for AppleHaat.
class ApiClient {
  final Dio dio;

  ApiClient({
    required SecureStorageService storageService,
    void Function()? onUnauthorized,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: ApiEndpoints.connectTimeout,
            receiveTimeout: ApiEndpoints.receiveTimeout,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    dio.interceptors.addAll([
      AuthInterceptor(
        storageService: storageService,
        onUnauthorized: onUnauthorized,
      ),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);
  }
}

/// Riverpod provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  return ApiClient(storageService: storageService);
});

/// Direct Dio instance provider
final dioProvider = Provider<Dio>((ref) {
  return ref.watch(apiClientProvider).dio;
});
