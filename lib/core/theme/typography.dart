// lib/core/theme/typography.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  static const String fontFamily = 'Poppins';

  // Light theme text styles
  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 96,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
    color: AppColors.onBackground,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 60,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
    color: AppColors.onBackground,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onBackground,
  );

  static const TextStyle headline4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.onBackground,
  );

  static const TextStyle headline5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.onBackground,
  );

  static const TextStyle headline6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: AppColors.onBackground,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: AppColors.onBackground,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.onBackground,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    color: AppColors.onPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.onBackground,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    color: AppColors.onBackground,
  );

  // Text theme for light mode
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: headline1,
      displayMedium: headline2,
      displaySmall: headline3,
      headlineMedium: headline4,
      headlineSmall: headline5,
      titleLarge: headline6,
      titleMedium: subtitle1,
      titleSmall: subtitle2,
      bodyLarge: bodyText1,
      bodyMedium: bodyText2,
      labelLarge: button,
      bodySmall: caption,
      labelSmall: overline,
    );
  }

  // Text theme for dark mode
  static TextTheme get textThemeDark {
    return TextTheme(
      displayLarge: headline1.copyWith(color: AppColors.onBackgroundDark),
      displayMedium: headline2.copyWith(color: AppColors.onBackgroundDark),
      displaySmall: headline3.copyWith(color: AppColors.onBackgroundDark),
      headlineMedium: headline4.copyWith(color: AppColors.onBackgroundDark),
      headlineSmall: headline5.copyWith(color: AppColors.onBackgroundDark),
      titleLarge: headline6.copyWith(color: AppColors.onBackgroundDark),
      titleMedium: subtitle1.copyWith(color: AppColors.onBackgroundDark),
      titleSmall: subtitle2.copyWith(color: AppColors.onBackgroundDark),
      bodyLarge: bodyText1.copyWith(color: AppColors.onBackgroundDark),
      bodyMedium: bodyText2.copyWith(color: AppColors.onBackgroundDark),
      labelLarge: button.copyWith(color: AppColors.onPrimaryDark),
      bodySmall: caption.copyWith(color: AppColors.onBackgroundDark),
      labelSmall: overline.copyWith(color: AppColors.onBackgroundDark),
    );
  }
}
