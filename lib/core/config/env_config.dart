import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Class yang mengelola konfigurasi environment aplikasi
class EnvConfig {
  // Environments yang didukung
  static const String devEnv = 'development';
  static const String stagingEnv = 'staging';
  static const String prodEnv = 'production';

  // Environment saat ini
  final String environment;
  final String apiBaseUrl;
  final int apiTimeout;

  // Firebase Configuration
  final String firebaseApiKey;
  final String firebaseAppId;
  final String firebaseMessagingSenderId;
  final String firebaseProjectId;
  final String firebaseStorageBucket;

  // Authentication
  final String authClientId;
  final String authClientSecret;

  // Payment Gateway
  final String stripePublishableKey;
  final String stripeSecretKey;
  final String midtransClientKey;
  final String midtransServerKey;

  // Feature Flags
  final bool enableSocialLogin;
  final bool enableApplePay;
  final bool enableGooglePay;
  final bool enableLiveChat;
  final bool enableLocationServices;

  // App Configuration
  final String appName;
  final String appVersion;
  final String minSupportedVersion;

  // Cache Configuration
  final int cacheDurationProducts;
  final int cacheDurationCategories;
  final int cacheDurationUserData;

  // Logging
  final bool enableDebugLogging;
  final bool enableCrashReporting;

  // Content Delivery Network
  final String cdnBaseUrl;

  // Singleton instance
  static EnvConfig? _instance;

  EnvConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.apiTimeout,
    required this.firebaseApiKey,
    required this.firebaseAppId,
    required this.firebaseMessagingSenderId,
    required this.firebaseProjectId,
    required this.firebaseStorageBucket,
    required this.authClientId,
    required this.authClientSecret,
    required this.stripePublishableKey,
    required this.stripeSecretKey,
    required this.midtransClientKey,
    required this.midtransServerKey,
    required this.enableSocialLogin,
    required this.enableApplePay,
    required this.enableGooglePay,
    required this.enableLiveChat,
    required this.enableLocationServices,
    required this.appName,
    required this.appVersion,
    required this.minSupportedVersion,
    required this.cacheDurationProducts,
    required this.cacheDurationCategories,
    required this.cacheDurationUserData,
    required this.enableDebugLogging,
    required this.enableCrashReporting,
    required this.cdnBaseUrl,
  });

  /// Loads environment variables from .env file and initializes the config
  static Future<void> initialize({String envFile = 'app.env'}) async {
    try {
      await dotenv.load(fileName: envFile);
      _instance = EnvConfig._fromEnv();
    } catch (e) {
      print('Error loading environment file: $e');
      // Buat instance dengan nilai default jika file env tidak dapat dimuat
      _instance = EnvConfig._withDefaults();
    }
  }

  /// Gets the singleton instance of EnvConfig
  static EnvConfig getInstance() {
    if (_instance == null) {
      throw Exception(
        'EnvConfig has not been initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  /// Creates EnvConfig from environment variables
  factory EnvConfig._fromEnv() {
    return EnvConfig._(
      // Defaulting to development if not specified
      environment: dotenv.env['ENVIRONMENT'] ?? devEnv,

      // API Configuration
      apiBaseUrl:
          dotenv.env['API_BASE_URL'] ?? 'https://api.alitaecommerce.com/v1',
      apiTimeout: int.tryParse(dotenv.env['API_TIMEOUT'] ?? '') ?? 30000,

      // Firebase Configuration
      firebaseApiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
      firebaseAppId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      firebaseMessagingSenderId:
          dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      firebaseProjectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      firebaseStorageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',

      // Authentication
      authClientId: dotenv.env['AUTH_CLIENT_ID'] ?? '',
      authClientSecret: dotenv.env['AUTH_CLIENT_SECRET'] ?? '',

      // Payment Gateway
      stripePublishableKey: dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '',
      stripeSecretKey: dotenv.env['STRIPE_SECRET_KEY'] ?? '',
      midtransClientKey: dotenv.env['MIDTRANS_CLIENT_KEY'] ?? '',
      midtransServerKey: dotenv.env['MIDTRANS_SERVER_KEY'] ?? '',

      // Feature Flags
      enableSocialLogin:
          dotenv.env['ENABLE_SOCIAL_LOGIN']?.toLowerCase() == 'true',
      enableApplePay: dotenv.env['ENABLE_APPLE_PAY']?.toLowerCase() == 'true',
      enableGooglePay: dotenv.env['ENABLE_GOOGLE_PAY']?.toLowerCase() == 'true',
      enableLiveChat: dotenv.env['ENABLE_LIVE_CHAT']?.toLowerCase() == 'true',
      enableLocationServices:
          dotenv.env['ENABLE_LOCATION_SERVICES']?.toLowerCase() == 'true',

      // App Configuration
      appName: dotenv.env['APP_NAME'] ?? 'Alita Ecommerce',
      appVersion: dotenv.env['APP_VERSION'] ?? '1.0.0',
      minSupportedVersion: dotenv.env['MIN_SUPPORTED_VERSION'] ?? '1.0.0',

      // Cache Configuration
      cacheDurationProducts:
          int.tryParse(dotenv.env['CACHE_DURATION_PRODUCTS'] ?? '') ?? 86400,
      cacheDurationCategories:
          int.tryParse(dotenv.env['CACHE_DURATION_CATEGORIES'] ?? '') ?? 86400,
      cacheDurationUserData:
          int.tryParse(dotenv.env['CACHE_DURATION_USER_DATA'] ?? '') ?? 604800,

      // Logging
      enableDebugLogging:
          dotenv.env['ENABLE_DEBUG_LOGGING']?.toLowerCase() == 'true',
      enableCrashReporting:
          dotenv.env['ENABLE_CRASH_REPORTING']?.toLowerCase() == 'true',

      // Content Delivery Network
      cdnBaseUrl:
          dotenv.env['CDN_BASE_URL'] ?? 'https://cdn.alitaecommerce.com',
    );
  }

  /// Creates EnvConfig with default values for fallback
  factory EnvConfig._withDefaults() {
    return EnvConfig._(
      environment: devEnv,
      apiBaseUrl: 'https://api.alitaecommerce.com/v1',
      apiTimeout: 30000,
      firebaseApiKey: '',
      firebaseAppId: '',
      firebaseMessagingSenderId: '',
      firebaseProjectId: '',
      firebaseStorageBucket: '',
      authClientId: '',
      authClientSecret: '',
      stripePublishableKey: '',
      stripeSecretKey: '',
      midtransClientKey: '',
      midtransServerKey: '',
      enableSocialLogin: false,
      enableApplePay: false,
      enableGooglePay: false,
      enableLiveChat: false,
      enableLocationServices: false,
      appName: 'Alita Ecommerce',
      appVersion: '1.0.0',
      minSupportedVersion: '1.0.0',
      cacheDurationProducts: 86400,
      cacheDurationCategories: 86400,
      cacheDurationUserData: 604800,
      enableDebugLogging: true,
      enableCrashReporting: false,
      cdnBaseUrl: 'https://cdn.alitaecommerce.com',
    );
  }

  /// Check if current environment is development
  bool get isDevelopment => environment == devEnv;

  /// Check if current environment is staging
  bool get isStaging => environment == stagingEnv;

  /// Check if current environment is production
  bool get isProduction => environment == prodEnv;

  /// Returns API URL for a specific endpoint
  String apiUrl(String endpoint) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$apiBaseUrl$path';
  }

  /// Returns CDN URL for a specific asset
  String cdnUrl(String asset) {
    final path = asset.startsWith('/') ? asset : '/$asset';
    return '$cdnBaseUrl$path';
  }

  /// Returns duration for cache in milliseconds
  Duration getCacheDuration(String type) {
    switch (type) {
      case 'products':
        return Duration(seconds: cacheDurationProducts);
      case 'categories':
        return Duration(seconds: cacheDurationCategories);
      case 'user_data':
        return Duration(seconds: cacheDurationUserData);
      default:
        return const Duration(hours: 1); // Default cache duration
    }
  }

  @override
  String toString() {
    return 'EnvConfig('
        'environment: $environment, '
        'apiBaseUrl: $apiBaseUrl, '
        'appName: $appName, '
        'appVersion: $appVersion'
        ')';
  }
}
