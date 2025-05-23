import 'package:dio/dio.dart';
import '../../utils/logger.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method;
    final uri = options.uri;

    Logger.d('REQUEST[$method] => $uri');
    Logger.d('Headers: ${options.headers}');

    if (options.data != null) {
      Logger.d('Body: ${options.data}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final method = response.requestOptions.method;
    final uri = response.requestOptions.uri;

    Logger.d('RESPONSE[$method] => $uri');
    Logger.d('Status: ${response.statusCode}');
    Logger.d('Body: ${response.data}');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final method = err.requestOptions.method;
    final uri = err.requestOptions.uri;

    Logger.e('ERROR[$method] => $uri');
    Logger.e('Status: ${err.response?.statusCode}');
    Logger.e('Body: ${err.response?.data}');

    handler.next(err);
  }
}
