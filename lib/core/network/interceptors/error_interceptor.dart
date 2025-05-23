// lib/core/network/interceptors/error_interceptor.dart
import 'package:dio/dio.dart';
import '../exceptions/api_exception.dart';
import '../exceptions/connection_exception.dart';
import '../exceptions/timeout_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(message: err.message ?? 'Connection timed out');

      case DioExceptionType.connectionError:
        throw ConnectionException(message: err.message ?? 'Connection error');

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        String message = 'Unknown error occurred';

        if (data != null && data is Map<String, dynamic>) {
          message = data['message'] ?? message;
        }

        throw ApiException(
          statusCode: statusCode ?? 500,
          message: message,
          data: data,
        );

      default:
        // For unknown or other errors
        throw ApiException(
          statusCode: 500,
          message: err.message ?? 'Unknown error occurred',
        );
    }
  }
}
