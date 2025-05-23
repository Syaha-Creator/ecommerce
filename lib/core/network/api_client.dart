// lib/core/network/api_client.dart (perbaikan)
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../config/app_config.dart';
import '../config/build_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import '../../app/di.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  late Dio dio;
  final EnvConfig _envConfig;
  final AppConfig _appConfig;
  final BuildConfig _buildConfig;
  final SecureStorage _secureStorage;

  ApiClient(
    this._envConfig,
    this._appConfig,
    this._buildConfig,
    this._secureStorage,
  ) {
    final baseOptions = BaseOptions(
      baseUrl: _envConfig.apiBaseUrl,
      connectTimeout: _appConfig.connectionTimeout,
      receiveTimeout: _appConfig.receiveTimeout,
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    dio = Dio(baseOptions);

    // Tambahkan interceptors
    final interceptors = <Interceptor>[];

    // Auth interceptor
    interceptors.add(AuthInterceptor(_secureStorage));

    // Error interceptor
    interceptors.add(ErrorInterceptor());

    // Logger hanya dalam mode debug atau jika logging diaktifkan
    if (_envConfig.enableDebugLogging || _buildConfig.isDebugMode) {
      interceptors.add(LoggerInterceptor());
    }

    // Tambahkan semua interceptors
    dio.interceptors.addAll(interceptors);
  }

  // Singleton factory
  static ApiClient? _instance;
  factory ApiClient.getInstance() {
    _instance ??= ApiClient(
      locator<EnvConfig>(),
      locator<AppConfig>(),
      locator<BuildConfig>(),
      locator<SecureStorage>(),
    );
    return _instance!;
  }

  // GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(endpoint, queryParameters: queryParameters);
    } catch (e) {
      rethrow; // Error akan ditangani oleh ErrorInterceptor
    }
  }

  // POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await dio.post(endpoint, data: data);
    } catch (e) {
      rethrow; // Error akan ditangani oleh ErrorInterceptor
    }
  }

  // PUT request
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await dio.put(endpoint, data: data);
    } catch (e) {
      rethrow; // Error akan ditangani oleh ErrorInterceptor
    }
  }

  // DELETE request
  Future<Response> delete(String endpoint, {dynamic data}) async {
    try {
      return await dio.delete(endpoint, data: data);
    } catch (e) {
      rethrow; // Error akan ditangani oleh ErrorInterceptor
    }
  }

  // PATCH request
  Future<Response> patch(String endpoint, {dynamic data}) async {
    try {
      return await dio.patch(endpoint, data: data);
    } catch (e) {
      rethrow; // Error akan ditangani oleh ErrorInterceptor
    }
  }

  // GET request eksternal (dengan URL lengkap)
  Future<Response> getExternal(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) {
    // Perbaikan: Ganti parameter baseUrl dengan options yang benar
    return dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(
          // Parameter yang benar adalah 'headers' bukan 'baseUrl'
          // Kita bisa mengganti baseUrl dengan cara lain
          ),
    );
  }

  // GET sumber CDN
  Future<Response> getCDNResource(String path) {
    final url = _envConfig.cdnUrl(path);
    // Panggil metode getExternal dengan URL CDN lengkap
    return getExternal(url);
  }
}
