// lib/app/app.dart (update untuk menambahkan BlocProvider)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/config/app_config.dart';
import '../core/config/build_config.dart';
import '../core/config/env_config.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import 'di.dart';
import 'router.dart';

class AlitaApp extends StatefulWidget {
  const AlitaApp({Key? key}) : super(key: key);

  @override
  State<AlitaApp> createState() => _AlitaAppState();
}

class _AlitaAppState extends State<AlitaApp> {
  final _appRouter = AppRouter();
  final _envConfig = locator<EnvConfig>();
  final _appConfig = locator<AppConfig>();
  final _buildConfig = locator<BuildConfig>();
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _themeMode = _appConfig.defaultThemeMode;

    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            _themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthCheckRequested()),
      child: MaterialApp(
        title: _envConfig.appName,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: _themeMode,
        onGenerateRoute: _appRouter.onGenerateRoute,
        initialRoute: '/',
        debugShowCheckedModeBanner: _buildConfig.enableDebugBanner,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id'),
          Locale('en', 'US'),
        ],
        locale: const Locale('id'),
      ),
    );
  }
}
