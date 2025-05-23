import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'env_config.dart';
import 'build_config.dart';

/// Class yang menyimpan konfigurasi dan pengaturan aplikasi
class AppConfig {
  // App info
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  // Theme settings
  final ThemeMode defaultThemeMode;
  final Locale defaultLocale;
  final bool enableDarkMode;
  final bool enableMultiLanguage;

  // Network settings
  final Duration connectionTimeout;
  final Duration receiveTimeout;
  final int maxApiRetries;
  final Duration apiRetryInterval;

  // Cache settings
  final Duration imageCacheDuration;
  final Duration productsCacheDuration;
  final Duration categoriesCacheDuration;
  final Duration userDataCacheDuration;

  // Pagination settings
  final int defaultPageSize;
  final int maxPageSize;

  // Currency settings
  final String defaultCurrency;
  final List<String> supportedCurrencies;

  // Feature flags
  final bool enablePushNotifications;
  final bool enableCrashReporting;
  final bool enablePerformanceMonitoring;
  final bool enableAnalytics;
  final bool enableOfflineMode;

  // Singleton instance
  static AppConfig? _instance;

  AppConfig._({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    required this.defaultThemeMode,
    required this.defaultLocale,
    required this.enableDarkMode,
    required this.enableMultiLanguage,
    required this.connectionTimeout,
    required this.receiveTimeout,
    required this.maxApiRetries,
    required this.apiRetryInterval,
    required this.imageCacheDuration,
    required this.productsCacheDuration,
    required this.categoriesCacheDuration,
    required this.userDataCacheDuration,
    required this.defaultPageSize,
    required this.maxPageSize,
    required this.defaultCurrency,
    required this.supportedCurrencies,
    required this.enablePushNotifications,
    required this.enableCrashReporting,
    required this.enablePerformanceMonitoring,
    required this.enableAnalytics,
    required this.enableOfflineMode,
  });

  /// Initialize the AppConfig
  static Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final envConfig = EnvConfig.getInstance();
    final buildConfig = BuildConfig.getInstance();

    _instance = AppConfig._(
      // App info
      appName: envConfig.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,

      // Theme settings
      defaultThemeMode: ThemeMode.light,
      defaultLocale: const Locale('id', 'ID'),
      enableDarkMode: true,
      enableMultiLanguage: true,

      // Network settings
      connectionTimeout: Duration(milliseconds: envConfig.apiTimeout),
      receiveTimeout: Duration(milliseconds: envConfig.apiTimeout),
      maxApiRetries: 3,
      apiRetryInterval: const Duration(seconds: 1),

      // Cache settings
      imageCacheDuration: const Duration(days: 7),
      productsCacheDuration: envConfig.getCacheDuration('products'),
      categoriesCacheDuration: envConfig.getCacheDuration('categories'),
      userDataCacheDuration: envConfig.getCacheDuration('user_data'),

      // Pagination settings
      defaultPageSize: 10,
      maxPageSize: 50,

      // Currency settings
      defaultCurrency: 'IDR',
      supportedCurrencies: ['IDR', 'USD', 'SGD', 'MYR'],

      // Feature flags - using environment values
      enablePushNotifications: !buildConfig.isDevelopment,
      enableCrashReporting: envConfig.enableCrashReporting,
      enablePerformanceMonitoring: !buildConfig.isDevelopment,
      enableAnalytics: !buildConfig.isDevelopment,
      enableOfflineMode: true,
    );
  }

  /// Get the singleton instance of AppConfig
  static AppConfig getInstance() {
    if (_instance == null) {
      throw Exception(
        'AppConfig has not been initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  /// Get the full app version string
  String get fullVersion => '$version+$buildNumber';

  /// Check if a specific feature is enabled
  bool isFeatureEnabled(String featureKey) {
    switch (featureKey) {
      case 'dark_mode':
        return enableDarkMode;
      case 'multi_language':
        return enableMultiLanguage;
      case 'push_notifications':
        return enablePushNotifications;
      case 'crash_reporting':
        return enableCrashReporting;
      case 'performance_monitoring':
        return enablePerformanceMonitoring;
      case 'analytics':
        return enableAnalytics;
      case 'offline_mode':
        return enableOfflineMode;
      default:
        return false;
    }
  }

  @override
  String toString() {
    return 'AppConfig('
        'appName: $appName, '
        'version: $fullVersion, '
        'defaultLocale: $defaultLocale, '
        'defaultThemeMode: $defaultThemeMode'
        ')';
  }
}
