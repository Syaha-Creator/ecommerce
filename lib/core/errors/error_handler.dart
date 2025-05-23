// lib/core/errors/error_handler.dart
import 'package:flutter/material.dart';
import '../network/exceptions/api_exception.dart';
import '../network/exceptions/connection_exception.dart';
import '../network/exceptions/timeout_exception.dart';
import 'crash_reporting.dart';
import '../config/build_config.dart';

class ErrorHandler {
  final CrashReporting _crashReporting;
  final BuildConfig _buildConfig;

  ErrorHandler(this._crashReporting, this._buildConfig);

  Future<String> handleError(dynamic error, StackTrace stackTrace) async {
    // Log the error
    print('Error: $error');
    print('StackTrace: $stackTrace');

    // Report to crash reporting service if not in development
    if (!_buildConfig.isDevelopment) {
      await _crashReporting.recordError(error, stackTrace);
    }

    // Return user-friendly error message based on error type
    if (error is ConnectionException) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again later.';
    } else if (error is ApiException) {
      switch (error.statusCode) {
        case 400:
          return 'Invalid request. Please check your input and try again.';
        case 401:
          return 'Authentication failed. Please login again.';
        case 403:
          return 'You do not have permission to access this resource.';
        case 404:
          return 'The requested resource was not found.';
        case 500:
        case 502:
        case 503:
          return 'Server error. Please try again later.';
        default:
          return error.message;
      }
    } else {
      // For generic errors
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  // Show a snackbar with the error message
  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Show a dialog with the error message
  Future<void> showErrorDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
