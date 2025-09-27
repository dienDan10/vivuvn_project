abstract interface class ISecureStorage {
  Future<void> write({required final String key, required final String value});
  Future<String?> read({required final String key});
  Future<void> delete({required final String key});
}
