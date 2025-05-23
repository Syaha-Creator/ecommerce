// lib/app/router.dart
import 'package:flutter/material.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';

/// Kelas router untuk navigasi di aplikasi
///
/// Ini adalah implementasi manual yang bisa digunakan
/// sampai kita mengimplementasikan auto_route dengan benar
class AppRouter {
  /// Metode untuk menghasilkan route berdasarkan nama route
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }

  /// Metode untuk navigasi ke halaman tertentu
  void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// Metode untuk navigasi ke halaman tertentu dan menghapus semua halaman sebelumnya
  void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Metode untuk navigasi ke halaman tertentu dan menghapus semua halaman sampai route tertentu
  void navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Metode untuk kembali ke halaman sebelumnya
  void goBack(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  /// Metode untuk delegate router
  /// Ini adalah metode sementara sampai kita mengimplementasikan auto_route
  RouterDelegate<Object> delegate() {
    return _AppRouterDelegate();
  }

  /// Metode untuk parser informasi route
  /// Ini adalah metode sementara sampai kita mengimplementasikan auto_route
  RouteInformationParser<Object> defaultRouteParser() {
    return _AppRouteInformationParser();
  }
}

/// Implementasi RouterDelegate untuk NavigatorAPI 2.0
/// Ini adalah implementasi sementara sampai kita mengimplementasikan auto_route
class _AppRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: const [MaterialPage(child: SplashPage())],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {
    // Implementasi sederhana untuk saat ini
  }
}

/// Implementasi RouteInformationParser untuk NavigatorAPI 2.0
/// Ini adalah implementasi sementara sampai kita mengimplementasikan auto_route
class _AppRouteInformationParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return routeInformation.location;
  }

  @override
  RouteInformation? restoreRouteInformation(Object configuration) {
    if (configuration is String) {
      return RouteInformation(location: configuration);
    }
    return null;
  }
}
