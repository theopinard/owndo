abstract interface class SyncAdapter {
  Future<void> upload(String path, String content);
  Future<String> download(String path);
  Future<List<String>> listFiles(String directoryPath);
  Future<void> delete(String path);
  Future<bool> fileExists(String path);
}
