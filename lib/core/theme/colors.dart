// lib/core/theme/colors.dart (ENHANCED)
import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF667eea); // Indigo
  static const Color primaryVariant = Color(0xFF303F9F); // Dark Indigo
  static const Color primaryLight = Color(0xFF7986CB); // Light Indigo
  static const Color primarySoft = Color(0xFFE8EAF6); // Very Light Indigo

  // Secondary Colors
  static const Color secondary = Color(0xFFFF4081); // Pink Accent
  static const Color secondaryVariant = Color(0xFFC51162); // Dark Pink
  static const Color secondaryLight = Color(0xFFFF80AB); // Light Pink
  static const Color secondarySoft = Color(0xFFFCE4EC); // Very Light Pink

  // Accent Colors
  static const Color accent = Color(0xFF00BCD4); // Cyan
  static const Color accentLight = Color(0xFF4DD0E1); // Light Cyan
  static const Color accentSoft = Color(0xFFE0F2F1); // Very Light Cyan

  // Gradient Colors
  static const Color gradientStart = Color(0xFF667eea);
  static const Color gradientMiddle = Color(0xFF764ba2);
  static const Color gradientEnd = Color(0xFFf093fb);

  // Alternative Gradients
  static const Color purpleStart = Color(0xFF667eea);
  static const Color purpleEnd = Color(0xFF764ba2);
  static const Color blueStart = Color(0xFF4facfe);
  static const Color blueEnd = Color(0xFF00f2fe);
  static const Color pinkStart = Color(0xFFfa709a);
  static const Color pinkEnd = Color(0xFFfee140);

  // Surface Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF212121);
  static const Color onSurface = Color(0xFF212121);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Dark theme colors
  static const Color primaryDark = Color(0xFF5C6BC0);
  static const Color primaryVariantDark = Color(0xFF3949AB);
  static const Color secondaryDark = Color(0xFFFF80AB);
  static const Color secondaryVariantDark = Color(0xFFF50057);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successSoft = Color(0xFFE8F5E8);

  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningSoft = Color(0xFFFFF8E1);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorSoft = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFCF6679);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoSoft = Color(0xFFE3F2FD);

  // Gray scale
  static const Color black = Color(0xFF000000);
  static const Color darkGray = Color(0xFF424242);
  static const Color gray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color extraLightGray = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // Overlay colors
  static const Color overlay = Color(0x4D000000); // 30% black
  static const Color overlayLight = Color(0x1A000000); // 10% black
  static const Color overlayDark = Color(0x66000000); // 40% black

  // Gradient Lists for easy usage
  static const List<Color> primaryGradient = [primary, primaryVariant];
  static const List<Color> secondaryGradient = [secondary, secondaryVariant];
  static const List<Color> accentGradient = [accent, accentLight];
  static const List<Color> purpleGradient = [purpleStart, purpleEnd];
  static const List<Color> blueGradient = [blueStart, blueEnd];
  static const List<Color> pinkGradient = [pinkStart, pinkEnd];
  static const List<Color> rainbowGradient = [
    gradientStart,
    gradientMiddle,
    gradientEnd
  ];

  // Success gradient
  static const List<Color> successGradient = [
    Color(0xFF56ab2f),
    Color(0xFFa8e6cf)
  ];

  // Warning gradient
  static const List<Color> warningGradient = [
    Color(0xFFf7971e),
    Color(0xFFffd200)
  ];

  // Error gradient
  static const List<Color> errorGradient = [
    Color(0xFFff416c),
    Color(0xFFff4b2b)
  ];

  // Helper methods for gradients
  static LinearGradient createGradient(
    List<Color> colors, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }

  static LinearGradient get defaultGradient => createGradient(primaryGradient);
  static LinearGradient get authGradient => createGradient(purpleGradient);
  static LinearGradient get cardGradient => createGradient(blueGradient);
  static LinearGradient get buttonGradient => createGradient(primaryGradient);
}
