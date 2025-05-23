// lib/app/di.dart
import 'package:get_it/get_it.dart';
import '../core/config/env_config.dart';
import '../core/config/app_config.dart';
import '../core/config/build_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/secure_storage.dart';
import '../core/storage/local_storage.dart';
import '../core/errors/error_handler.dart';
import '../core/errors/crash_reporting.dart';

final locator = GetIt.instance;

Future<void> configureDependencies() async {
  // Config
  locator.registerSingleton<EnvConfig>(EnvConfig.getInstance());
  locator.registerSingleton<BuildConfig>(BuildConfig.getInstance());
  locator.registerSingleton<AppConfig>(AppConfig.getInstance());

  // Storage
  locator.registerLazySingleton<SecureStorage>(() => SecureStorage());

  final localStorage = LocalStorage();
  await localStorage.init();
  locator.registerLazySingleton<LocalStorage>(() => localStorage);

  // Error handling
  locator.registerLazySingleton<CrashReporting>(() => CrashReporting());
  locator.registerLazySingleton<ErrorHandler>(
    () => ErrorHandler(locator<CrashReporting>(), locator<BuildConfig>()),
  );

  // Network
  locator.registerLazySingleton<ApiClient>(
    () => ApiClient(
      locator<EnvConfig>(),
      locator<AppConfig>(),
      locator<BuildConfig>(),
      locator<SecureStorage>(),
    ),
  );

  // Register feature-specific dependencies
  await _registerFeatureModules();
}

Future<void> _registerFeatureModules() async {
  // Import and register feature-specific modules
  // This allows each feature to register its own dependencies

  // Auth feature
  // await registerAuthDependencies();

  // Product feature
  // await registerProductDependencies();

  // Cart feature
  // await registerCartDependencies();

  // ... other features
}
