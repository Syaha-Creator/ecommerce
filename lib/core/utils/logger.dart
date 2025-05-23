import 'package:flutter/foundation.dart';

class Logger {
  static bool enableLogs = true;

  static void d(dynamic message) {
    if (enableLogs && kDebugMode) {
      print('💙 DEBUG: $message');
    }
  }

  static void i(dynamic message) {
    if (enableLogs) {
      print('💚 INFO: $message');
    }
  }

  static void w(dynamic message) {
    if (enableLogs) {
      print('💛 WARNING: $message');
    }
  }

  static void e(dynamic message) {
    if (enableLogs) {
      print('❤️ ERROR: $message');
    }
  }

  static void success(dynamic message) {
    if (enableLogs) {
      print('✅ SUCCESS: $message');
    }
  }

  static void logRequest(
    String method,
    Uri uri,
    Map<String, dynamic>? headers,
    dynamic data,
  ) {
    if (!enableLogs) return;

    d(
      '┌─────────────────────────────────────────────────────────────────────────',
    );
    d('│ 🔷 REQUEST[$method] => $uri');
    d('│ 🔶 Headers: $headers');
    if (data != null) {
      d('│ 📦 Body: $data');
    }
    d(
      '└─────────────────────────────────────────────────────────────────────────',
    );
  }

  static void logResponse(
    String method,
    Uri uri,
    int? statusCode,
    dynamic data,
  ) {
    if (!enableLogs) return;

    d(
      '┌─────────────────────────────────────────────────────────────────────────',
    );
    d('│ 🟢 RESPONSE[$method] => $uri');
    d('│ 🔢 Status: $statusCode');
    d('│ 📦 Body: $data');
    d(
      '└─────────────────────────────────────────────────────────────────────────',
    );
  }

  static void logError(String method, Uri uri, int? statusCode, dynamic data) {
    if (!enableLogs) return;

    e(
      '┌─────────────────────────────────────────────────────────────────────────',
    );
    e('│ 🔴 ERROR[$method] => $uri');
    e('│ 🔢 Status: $statusCode');
    e('│ 📦 Body: $data');
    e(
      '└─────────────────────────────────────────────────────────────────────────',
    );
  }
}
