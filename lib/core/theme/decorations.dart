import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimensions.dart';

/// Kelas yang berisi semua dekorasi yang digunakan di seluruh aplikasi
/// seperti box shadows, gradients, borders, dan dekorasi umum lainnya
class AppDecorations {
  // Box Shadows
  static List<BoxShadow> get lightShadow => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get largeShadow => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.12),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get bottomNavShadow => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ];

  // Box Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        boxShadow: lightShadow,
      );

  static BoxDecoration get cardDecorationDark => BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        boxShadow: lightShadow,
      );

  static BoxDecoration get productCardDecoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        boxShadow: lightShadow,
      );

  static BoxDecoration get bottomSheetDecoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
          topRight: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
        boxShadow: largeShadow,
      );

  static BoxDecoration get dialogDecoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        boxShadow: largeShadow,
      );

  static BoxDecoration get searchBarDecoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        boxShadow: lightShadow,
      );

  // Input Decorations
  static InputDecoration searchInputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surface,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  static InputDecoration formInputDecoration({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.gray, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.gray, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  // Gradient Decorations
  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryVariant],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get secondaryGradient => const LinearGradient(
        colors: [AppColors.secondary, AppColors.secondaryVariant],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get featuredItemGradient => LinearGradient(
        colors: [
          AppColors.black.withOpacity(0.8),
          AppColors.black.withOpacity(0.0),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  // Badge Decorations
  static BoxDecoration badgeDecoration({required Color color}) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      );

  static BoxDecoration get discountBadgeDecoration => BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      );

  static BoxDecoration get newBadgeDecoration => BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      );

  static BoxDecoration get outOfStockBadgeDecoration => BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      );

  // Status Badge Decorations
  static BoxDecoration get successBadgeDecoration => BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        border: Border.all(color: AppColors.success),
      );

  static BoxDecoration get warningBadgeDecoration => BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        border: Border.all(color: AppColors.warning),
      );

  static BoxDecoration get errorBadgeDecoration => BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        border: Border.all(color: AppColors.error),
      );

  static BoxDecoration get infoBadgeDecoration => BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        border: Border.all(color: AppColors.info),
      );

  // Dividers
  static Divider get divider =>
      const Divider(height: 1, thickness: 1, color: AppColors.lightGray);

  static Divider get dividerWithSpacing => const Divider(
        height: AppDimensions.marginMedium * 2,
        thickness: 1,
        color: AppColors.lightGray,
      );

  // Container Decorations
  static BoxDecoration get roundedContainerDecoration => BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
      );

  static BoxDecoration get quantitySelectorDecoration => BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      );

  // Shimmer Loading Effects
  static BoxDecoration get shimmerBaseDecoration => BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      );

  static BoxDecoration get shimmerHighlightDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      );
}
