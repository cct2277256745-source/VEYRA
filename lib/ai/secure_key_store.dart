/// API Key 安全存储抽象（AGENTS §6：Key 不落明文）。
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureKeyStore {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

/// 系统安全存储（macOS Keychain / Windows DPAPI，经 flutter_secure_storage）。
class SecureStorageKeyStore implements SecureKeyStore {
  /// macOS 默认走数据保护 Keychain（要求开发签名 entitlement），
  /// 本地个人版改用传统登录 Keychain 即可安全保存。
  SecureStorageKeyStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
                mOptions: MacOsOptions(usesDataProtectionKeychain: false));

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// 测试与未授权场景下的内存实现（进程结束即清空，绝不写盘）。
class InMemoryKeyStore implements SecureKeyStore {
  final Map<String, String> _values = {};

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> delete(String key) async => _values.remove(key);
}
