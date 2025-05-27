import '../models/product_model.dart';
import '../models/category_model.dart';
import '../../../../core/storage/hive_service.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> clearCache();
  Future<bool> isCacheValid();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String productsBoxKey = 'products_box';
  static const String categoriesBoxKey = 'categories_box';
  static const String cacheInfoBoxKey = 'cache_info_box';
  static const String lastCachedKey = 'last_cached_time';
  static const Duration cacheValidDuration = Duration(hours: 24);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final box =
          await HiveService.openBox<Map<dynamic, dynamic>>(productsBoxKey);

      // Clear existing cache
      await box.clear();

      // Cache new products
      for (var i = 0; i < products.length; i++) {
        await box.put(i.toString(), products[i].toJson());
      }

      // Update cache timestamp
      await _updateCacheTimestamp();
    } catch (e) {
      throw Exception('Failed to cache products: $e');
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final box =
          await HiveService.openBox<Map<dynamic, dynamic>>(productsBoxKey);

      final products = <ProductModel>[];
      for (var i = 0; i < box.length; i++) {
        final json = box.get(i.toString());
        if (json != null) {
          products.add(ProductModel.fromJson(Map<String, dynamic>.from(json)));
        }
      }

      return products;
    } catch (e) {
      throw Exception('Failed to get cached products: $e');
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final box =
          await HiveService.openBox<Map<dynamic, dynamic>>(categoriesBoxKey);

      // Clear existing cache
      await box.clear();

      // Cache new categories
      for (var i = 0; i < categories.length; i++) {
        await box.put(i.toString(), categories[i].toJson());
      }

      // Update cache timestamp
      await _updateCacheTimestamp();
    } catch (e) {
      throw Exception('Failed to cache categories: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      final box =
          await HiveService.openBox<Map<dynamic, dynamic>>(categoriesBoxKey);

      final categories = <CategoryModel>[];
      for (var i = 0; i < box.length; i++) {
        final json = box.get(i.toString());
        if (json != null) {
          categories
              .add(CategoryModel.fromJson(Map<String, dynamic>.from(json)));
        }
      }

      return categories;
    } catch (e) {
      throw Exception('Failed to get cached categories: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await HiveService.clear<Map<dynamic, dynamic>>(productsBoxKey);
      await HiveService.clear<Map<dynamic, dynamic>>(categoriesBoxKey);
      await HiveService.clear<String>(cacheInfoBoxKey);
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final box = await HiveService.openBox<String>(cacheInfoBoxKey);
      final lastCachedString = box.get(lastCachedKey);

      if (lastCachedString == null) {
        return false;
      }

      final lastCached = DateTime.parse(lastCachedString);
      final now = DateTime.now();

      return now.difference(lastCached) < cacheValidDuration;
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateCacheTimestamp() async {
    final box = await HiveService.openBox<String>(cacheInfoBoxKey);
    await box.put(lastCachedKey, DateTime.now().toIso8601String());
  }
}
