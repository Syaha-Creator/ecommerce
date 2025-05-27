// lib/features/product/domain/repositories/product_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../entities/category.dart';
import '../entities/review.dart';

abstract class ProductRepository {
  // Product operations
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? sortBy,
    bool? featured,
  });

  Future<Either<Failure, Product>> getProductById(String productId);

  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
  });

  // Category operations
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, Category>> getCategoryById(String categoryId);

  // Review operations
  Future<Either<Failure, List<Review>>> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, Review>> addProductReview({
    required String productId,
    required double rating,
    String? comment,
    List<String>? images,
  });

  // Caching operations
  Future<Either<Failure, void>> cacheProducts(List<Product> products);

  Future<Either<Failure, List<Product>>> getCachedProducts();

  Future<Either<Failure, void>> clearProductCache();
}
