// lib/core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAuthToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check for new token in headers and store it if available
    final newToken = response.headers.value('new-auth-token');
    if (newToken != null) {
      _secureStorage.saveAuthToken(newToken);
    }

    // Continue with the response
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle authentication errors (401)
    if (err.response?.statusCode == 401) {
      // Handle token refresh or logout
      // You might want to navigate to login screen or refresh token
    }

    // Continue with the error
    handler.next(err);
  }
}
