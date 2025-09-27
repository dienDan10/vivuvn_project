import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flutter_sercure_storage_provider.dart';
import 'isecure_storage.dart';
import 'secure_storage.dart';

final secureStorageProvider = Provider<ISecureStorage>((final ref) {
  final flutterSecureStorage = ref.watch(flutterSecureStorageProvider);
  return SecureStorage(flutterSecureStorage);
});
