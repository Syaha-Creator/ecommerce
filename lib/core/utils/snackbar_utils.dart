// lib/core/utils/snackbar_utils.dart
import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String content,
  SnackBarAction? action,
  Color backgroundColor = const Color(0xFF667eea),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      action: action,
    ),
  );
}
