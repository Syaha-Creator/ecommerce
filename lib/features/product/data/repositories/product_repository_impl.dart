import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/exceptions/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? sortBy,
    bool? featured,
  }) async {
    try {
      // Check network connection
      if (await networkInfo.isConnected) {
        try {
          // Get products from remote
          final remoteProducts = await remoteDataSource.getProducts(
            page: page,
            limit: limit,
            categoryId: categoryId,
            sortBy: sortBy,
            featured: featured,
          );

          // Cache the first page for offline access
          if (page == 1) {
            await localDataSource.cacheProducts(remoteProducts);
          }

          // Convert to entities
          final products =
              remoteProducts.map((model) => model.toEntity()).toList();
          return Right(products);
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        } catch (e) {
          return Left(ServerFailure(message: 'Failed to get products: $e'));
        }
      } else {
        // No internet connection, try to get cached data
        try {
          final localProducts = await localDataSource.getCachedProducts();

          if (localProducts.isEmpty) {
            return const Left(NetworkFailure(
              message: 'No internet connection and no cached data available',
            ));
          }

          // Apply filters on cached data
          var filteredProducts = localProducts;

          if (categoryId != null) {
            filteredProducts = filteredProducts
                .where((p) => p.category.id == categoryId)
                .toList();
          }

          if (featured != null) {
            filteredProducts = filteredProducts
                .where((p) => p.isFeatured == featured)
                .toList();
          }

          // Apply sorting
          if (sortBy != null) {
            filteredProducts = _sortProducts(filteredProducts, sortBy);
          }

          // Apply pagination
          final startIndex = (page - 1) * limit;
          final endIndex = startIndex + limit;

          if (startIndex >= filteredProducts.length) {
            return const Right([]);
          }

          final paginatedProducts = filteredProducts.sublist(
            startIndex,
            endIndex > filteredProducts.length
                ? filteredProducts.length
                : endIndex,
          );

          // Convert to entities
          final products =
              paginatedProducts.map((model) => model.toEntity()).toList();
          return Right(products);
        } on CacheException catch (e) {
          return Left(CacheFailure(message: e.message));
        }
      }
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String productId) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteProduct =
              await remoteDataSource.getProductById(productId);
          return Right(remoteProduct.toEntity());
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // Try to find in cache
        try {
          final cachedProducts = await localDataSource.getCachedProducts();
          final product = cachedProducts.firstWhere(
            (p) => p.id == productId,
            orElse: () => throw CacheException('Product not found in cache'),
          );
          return Right(product.toEntity());
        } on CacheException catch (e) {
          return Left(CacheFailure(message: e.message));
        }
      }
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get product: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final searchResults = await remoteDataSource.searchProducts(
            query: query,
            page: page,
            limit: limit,
            categoryId: categoryId,
            minPrice: minPrice,
            maxPrice: maxPrice,
          );

          final products =
              searchResults.map((model) => model.toEntity()).toList();
          return Right(products);
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // Search in cached products
        try {
          final cachedProducts = await localDataSource.getCachedProducts();

          final searchResults = cachedProducts.where((product) {
            final matchesQuery = product.name
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase());
            final matchesCategory =
                categoryId == null || product.category.id == categoryId;
            final matchesMinPrice =
                minPrice == null || product.finalPrice >= minPrice;
            final matchesMaxPrice =
                maxPrice == null || product.finalPrice <= maxPrice;

            return matchesQuery &&
                matchesCategory &&
                matchesMinPrice &&
                matchesMaxPrice;
          }).toList();

          // Apply pagination
          final startIndex = (page - 1) * limit;
          final endIndex = startIndex + limit;

          if (startIndex >= searchResults.length) {
            return const Right([]);
          }

          final paginatedResults = searchResults.sublist(
            startIndex,
            endIndex > searchResults.length ? searchResults.length : endIndex,
          );

          final products =
              paginatedResults.map((model) => model.toEntity()).toList();
          return Right(products);
        } on CacheException catch (e) {
          return Left(CacheFailure(message: e.message));
        }
      }
    } catch (e) {
      return Left(UnknownFailure(message: 'Search failed: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteCategories = await remoteDataSource.getCategories();

          // Cache categories
          await localDataSource.cacheCategories(remoteCategories);

          final categories =
              remoteCategories.map((model) => model.toEntity()).toList();
          return Right(categories);
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // Get cached categories
        try {
          final cachedCategories = await localDataSource.getCachedCategories();

          if (cachedCategories.isEmpty) {
            return const Left(NetworkFailure(
              message:
                  'No internet connection and no cached categories available',
            ));
          }

          final categories =
              cachedCategories.map((model) => model.toEntity()).toList();
          return Right(categories);
        } on CacheException catch (e) {
          return Left(CacheFailure(message: e.message));
        }
      }
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get categories: $e'));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String categoryId) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteCategory =
              await remoteDataSource.getCategoryById(categoryId);
          return Right(remoteCategory.toEntity());
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // Try to find in cache
        try {
          final cachedCategories = await localDataSource.getCachedCategories();
          final category = cachedCategories.firstWhere(
            (c) => c.id == categoryId,
            orElse: () => throw CacheException('Category not found in cache'),
          );
          return Right(category.toEntity());
        } on CacheException catch (e) {
          return Left(CacheFailure(message: e.message));
        }
      }
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get category: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
  }) async {
    // Reviews require internet connection (no caching for now)
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Internet connection required to load reviews',
      ));
    }

    try {
      final reviews = await remoteDataSource.getProductReviews(
        productId: productId,
        page: page,
        limit: limit,
      );

      final reviewEntities = reviews.map((model) => model.toEntity()).toList();
      return Right(reviewEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get reviews: $e'));
    }
  }

  @override
  Future<Either<Failure, Review>> addProductReview({
    required String productId,
    required double rating,
    String? comment,
    List<String>? images,
  }) async {
    // Adding review requires internet connection
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'Internet connection required to submit review',
      ));
    }

    try {
      final review = await remoteDataSource.addProductReview(
        productId: productId,
        rating: rating,
        comment: comment,
        images: images,
      );

      return Right(review.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to add review: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheProducts(List<Product> products) async {
    try {
      final productModels =
          products.map((product) => ProductModel.fromEntity(product)).toList();

      await localDataSource.cacheProducts(productModels);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to cache products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getCachedProducts() async {
    try {
      final cachedProducts = await localDataSource.getCachedProducts();
      final products = cachedProducts.map((model) => model.toEntity()).toList();
      return Right(products);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get cached products: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearProductCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to clear cache: $e'));
    }
  }

  // Helper method to sort products
  List<ProductModel> _sortProducts(List<ProductModel> products, String sortBy) {
    switch (sortBy) {
      case 'price_low_to_high':
        products.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
      case 'price_high_to_low':
        products.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case 'rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'name':
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
    return products;
  }
}
