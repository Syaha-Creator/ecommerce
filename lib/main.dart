// lib/main.dart
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'core/config/env_config.dart';
import 'core/config/app_config.dart';
import 'core/config/build_config.dart';
import 'core/storage/hive_service.dart';
import 'core/errors/crash_reporting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize configurations
  await _initializeConfigurations();

  // Initialize local database
  await HiveService.init();

  // Setup dependency injection
  await configureDependencies();

  // Initialize crash reporting
  await locator<CrashReporting>().initialize();

  // Run application
  runApp(const AlitaApp());
}

Future<void> _initializeConfigurations() async {
  // Determine which env file to load based on build mode
  String envFileName = 'app.env'; // Default

  // Logic to choose correct env file
  if (const bool.fromEnvironment('dart.vm.product') == false) {
    // Debug mode - use development env
    envFileName = 'app.env';
  } else {
    // Determine from build arguments (can be set via command line or launch configs)
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: '');
    if (flavor == 'staging') {
      envFileName = 'app.staging.env';
    } else if (flavor == 'production') {
      envFileName = 'app.prod.env';
    }
  }

  // Load environment variables
  await EnvConfig.initialize(envFile: envFileName);

  // Initialize build config
  BuildConfig.initialize();

  // Initialize app config
  await AppConfig.initialize();

  // Print configuration details in debug mode
  if (BuildConfig.getInstance().isDebugMode) {
    final env = EnvConfig.getInstance();
    final app = AppConfig.getInstance();
    final build = BuildConfig.getInstance();

    print('===== ALITA E-COMMERCE CONFIGURATION =====');
    print('Environment: ${env.environment}');
    print('API Base URL: ${env.apiBaseUrl}');
    print('App Name: ${env.appName}');
    print('App Version: ${app.fullVersion}');
    print('Build Flavor: ${build.flavor}');
    print('Debug Mode: ${build.isDebugMode}');
    print('=======================================');
  }
}
