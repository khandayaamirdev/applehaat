import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/exceptions.dart';

/// SecureStorageService provides hardware-encrypted key-value persistence.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw CacheException('Failed to write to secure storage: $e');
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw CacheException('Failed to read from secure storage: $e');
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw CacheException('Failed to delete from secure storage: $e');
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw CacheException('Failed to clear secure storage: $e');
    }
  }
}

/// Riverpod provider for SecureStorageService
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService();
});
