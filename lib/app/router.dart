// lib/app/router.dart
import 'package:flutter/material.dart';
import '../features/product/presentation/pages/product_pages.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/product/presentation/pages/product_detail_page.dart';
import '../features/product/presentation/pages/product_search_page.dart';

/// Kelas router untuk navigasi di aplikasi
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

      // Product Routes
      case '/products':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProductsPage(
            categoryId: args?['categoryId'],
            categoryName: args?['categoryName'],
          ),
        );

      case '/product-detail':
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(productId: productId),
        );

      case '/product-search':
        return MaterialPageRoute(builder: (_) => const ProductSearchPage());

      // Cart Route (placeholder for now)
      case '/cart':
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Cart')),
            body: const Center(child: Text('Cart Page - Coming Soon')),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
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
}
