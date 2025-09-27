import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'isecure_storage.dart';

final class SecureStorage implements ISecureStorage {
  SecureStorage(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  @override
  Future<void> write({
    required final String key,
    required final String value,
  }) async {
    return await _flutterSecureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required final String key}) async {
    return await _flutterSecureStorage.read(key: key);
  }

  @override
  Future<void> delete({required final String key}) async {
    return await _flutterSecureStorage.delete(key: key);
  }
}
