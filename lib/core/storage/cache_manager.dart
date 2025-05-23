import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppCacheManager {
  static const key = 'alitaEcommerceCache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  // Get file from cache or network
  static Future<FileInfo?> getFileFromCache(String url) async {
    return await instance.getFileFromCache(url);
  }

  // Download and cache file
  static Future<FileInfo> downloadFile(String url) async {
    return await instance.downloadFile(url);
  }

  // Remove file from cache
  static Future<void> removeFile(String url) async {
    await instance.removeFile(url);
  }

  // Clear cache
  static Future<void> clearCache() async {
    await instance.emptyCache();
  }
}
