// lib/core/config/build_config.dart (perbaikan)
import 'package:flutter/foundation.dart';
import 'env_config.dart';

/// Class yang menangani konfigurasi build-specific
class BuildConfig {
  // Build flavors
  static const String flavorDevelopment = 'development';
  static const String flavorStaging = 'staging';
  static const String flavorProduction = 'production';

  // Current flavor
  final String flavor;

  // Build-specific parameters
  final bool isDebugMode;
  final bool isReleaseMode;
  final bool isProfileMode;

  // UI configurations
  final bool enablePerformanceOverlay;
  final bool enableDebugBanner;
  final bool enableDevTools;

  // Backend and API interactions
  final bool useMockResponses;
  final bool useSecureConnection;

  // Testing/Quality
  final bool runUnitTests;
  final bool runWidgetTests;
  final bool runIntegrationTests;

  // Singleton instance
  static BuildConfig? _instance;

  BuildConfig._({
    required this.flavor,
    required this.isDebugMode,
    required this.isReleaseMode,
    required this.isProfileMode,
    required this.enablePerformanceOverlay,
    required this.enableDebugBanner,
    required this.enableDevTools,
    required this.useMockResponses,
    required this.useSecureConnection,
    required this.runUnitTests,
    required this.runWidgetTests,
    required this.runIntegrationTests,
  });

  /// Initialize the BuildConfig based on current environment
  static void initialize({String? overrideFlavor}) {
    // Get current build modes
    const isDebug = kDebugMode;
    const isRelease = kReleaseMode;
    const isProfile = kProfileMode;

    // Get environment from EnvConfig
    final envConfig = EnvConfig.getInstance();

    // Determine flavor (override, env-based, or default)
    final flavor = overrideFlavor ??
        (envConfig.environment.isNotEmpty
            ? envConfig.environment
            : flavorDevelopment);

    _instance = BuildConfig._(
      flavor: flavor,
      isDebugMode: isDebug,
      isReleaseMode: isRelease,
      isProfileMode: isProfile,

      // UI configurations
      enablePerformanceOverlay: isDebug && flavor != flavorProduction,
      enableDebugBanner: isDebug && flavor != flavorProduction,
      enableDevTools: isDebug,

      // API configurations
      useMockResponses: flavor == flavorDevelopment && isDebug,
      useSecureConnection: flavor != flavorDevelopment,

      // Testing configurations
      runUnitTests: isDebug && flavor == flavorDevelopment,
      runWidgetTests:
          isDebug && (flavor == flavorDevelopment || flavor == flavorStaging),
      runIntegrationTests: isDebug && flavor == flavorStaging,
    );
  }

  /// Get the singleton instance of BuildConfig
  static BuildConfig getInstance() {
    if (_instance == null) {
      throw Exception(
        'BuildConfig has not been initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  /// Check if current flavor is development
  bool get isDevelopment => flavor == flavorDevelopment;

  /// Check if current flavor is staging
  bool get isStaging => flavor == flavorStaging;

  /// Check if current flavor is production
  bool get isProduction => flavor == flavorProduction;

  @override
  String toString() {
    return 'BuildConfig('
        'flavor: $flavor, '
        'isDebugMode: $isDebugMode, '
        'isReleaseMode: $isReleaseMode, '
        'useMockResponses: $useMockResponses'
        ')';
  }
}
