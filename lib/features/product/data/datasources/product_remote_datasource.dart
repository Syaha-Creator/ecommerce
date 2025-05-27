// lib/features/product/data/datasources/product_remote_datasource.dart (update _getMockProducts method)
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/review_model.dart';
import '../models/variant_model.dart';

// Add import for Random at the top of the file
import 'dart:math';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? sortBy,
    bool? featured,
  });

  Future<ProductModel> getProductById(String productId);

  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
  });

  Future<List<CategoryModel>> getCategories();

  Future<CategoryModel> getCategoryById(String categoryId);

  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
  });

  Future<ReviewModel> addProductReview({
    required String productId,
    required double rating,
    String? comment,
    List<String>? images,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(ApiClient apiClient);

  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? sortBy,
    bool? featured,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return _getMockProducts();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final products = _getMockProducts();
      return products.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception('Product not found'),
      );
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final products = _getMockProducts();
      return products.where((product) {
        final matchesQuery =
            product.name.toLowerCase().contains(query.toLowerCase()) ||
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
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return CategoryModel.dummyCategories();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final categories = CategoryModel.dummyCategories();
      return categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => throw Exception('Category not found'),
      );
    } catch (e) {
      throw Exception('Failed to get category: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return List.generate(
        5,
        (index) => ReviewModel.dummy(
          productId: productId,
          rating: 3.0 + (index % 3),
        ),
      );
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }

  @override
  Future<ReviewModel> addProductReview({
    required String productId,
    required double rating,
    String? comment,
    List<String>? images,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return ReviewModel.dummy(
        productId: productId,
        rating: rating,
        comment: comment,
      );
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  // Updated mock data generator with realistic product names
  List<ProductModel> _getMockProducts() {
    final categories = CategoryModel.dummyCategories();
    final products = <ProductModel>[];

    // Product names by category
    final productNames = {
      'Electronics': [
        'Smartphone X Pro',
        'Laptop Ultra Slim',
        'Wireless Earbuds Pro',
        'Smart Watch Series 5',
        'Tablet Pro 12.9"',
        'Gaming Console Next',
        'Bluetooth Speaker',
        'Power Bank 20000mAh',
      ],
      'Fashion': [
        'Casual T-Shirt Premium',
        'Denim Jeans Slim Fit',
        'Summer Dress Floral',
        'Leather Jacket Classic',
        'Sneakers Sport Edition',
        'Formal Shirt Business',
        'Winter Coat Premium',
        'Accessories Set',
      ],
      'Home & Living': [
        'Sofa Set Modern',
        'Coffee Table Glass',
        'Bed Frame Queen Size',
        'Dining Table Set',
        'Office Chair Ergonomic',
        'Bookshelf Wooden',
        'LED Ceiling Light',
        'Carpet Persian Style',
      ],
      'Beauty & Health': [
        'Face Serum Vitamin C',
        'Body Lotion Moisturizing',
        'Hair Care Set Complete',
        'Makeup Kit Professional',
        'Sunscreen SPF 50+',
        'Essential Oil Set',
        'Face Mask Collection',
        'Perfume Luxury Edition',
      ],
      'Sports & Outdoor': [
        'Yoga Mat Premium',
        'Dumbbell Set 20kg',
        'Running Shoes Pro',
        'Camping Tent 4 Person',
        'Bicycle Mountain Pro',
        'Swimming Goggles',
        'Fitness Tracker Band',
        'Outdoor Backpack 40L',
      ],
      'Food & Drinks': [
        'Organic Coffee Beans',
        'Green Tea Leaves',
        'Chocolate Bar Premium',
        'Protein Shake Mix',
        'Healthy Snacks Pack',
        'Mineral Water Bottle',
        'Energy Drink',
        'Fruit Juice Pack',
      ],
      'Books': [
        'Bestseller Novel',
        'Self-Help Book',
        'Cookbook Collection',
        'History Encyclopedia',
        'Science Fiction Series',
        'Children Story Book',
        'Educational Textbook',
        'Art and Design Book',
      ],
      'Toys': [
        'Action Figure Set',
        'Puzzle Game',
        'Building Blocks',
        'Remote Control Car',
        'Board Game Classic',
        'Stuffed Animal',
        'Educational Toy',
        'Outdoor Play Set',
      ],
    };

    // Generate products for each category
    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      final categoryProducts = productNames[category.name] ?? [];

      for (var j = 0; j < categoryProducts.length; j++) {
        final productIndex = i * categoryProducts.length + j;
        final hasDiscount = productIndex % 3 == 0;
        final basePrice = 50000.0 + (productIndex * 45000);
        final price = basePrice + (Random().nextDouble() * 200000);

        products.add(
          ProductModel(
            id: 'prod_$productIndex',
            name: categoryProducts[j],
            description:
                'Premium quality ${categoryProducts[j].toLowerCase()} from ${category.name} category. '
                'This product features exceptional build quality and comes with a 1-year warranty. '
                'Perfect for daily use with modern design and functionality.',
            images: [
              'https://picsum.photos/400/400?random=$productIndex',
              'https://picsum.photos/400/400?random=${productIndex + 100}',
              'https://picsum.photos/400/400?random=${productIndex + 200}',
            ],
            price: price,
            discountPrice: hasDiscount ? price * 0.8 : null,
            discountPercentage: hasDiscount ? 20 : null,
            category: category,
            brand: 'Brand ${(productIndex % 5) + 1}',
            rating: 3.5 + (productIndex % 3) * 0.5,
            reviewCount: 10 + productIndex * 5,
            stock: 50 - (productIndex % 10),
            isActive: true,
            isFeatured: productIndex % 4 == 0,
            variants: productIndex % 2 == 0 ? _generateVariants() : null,
            tags: ['new', 'popular', category.name.toLowerCase()],
            createdAt:
                DateTime.now().subtract(Duration(days: 30 - productIndex)),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }

    return products;
  }

  List<VariantModel> _generateVariants() {
    final variants = <VariantModel>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Size variants
    final sizes = ['S', 'M', 'L', 'XL'];
    for (var i = 0; i < sizes.length; i++) {
      variants.add(VariantModel(
        id: 'var_size_${sizes[i].toLowerCase()}_${timestamp + i}',
        name: 'Size - ${sizes[i]}',
        type: 'size',
        value: sizes[i],
        additionalPrice: null,
        stock: 20 + i * 5,
        sku: 'SKU-SIZE-${sizes[i]}',
        imageUrl: null,
        isActive: true,
      ));
    }

    final colors = ['Red', 'Blue', 'Black', 'White'];
    for (var i = 0; i < colors.length; i++) {
      variants.add(VariantModel(
        id: 'var_color_${colors[i].toLowerCase()}_${timestamp + 100 + i}',
        name: 'Color - ${colors[i]}',
        type: 'color',
        value: colors[i],
        additionalPrice: null,
        stock: 15 + i * 3,
        sku: 'SKU-COLOR-${colors[i]}',
        imageUrl: null,
        isActive: true,
      ));
    }

    return variants;
  }

  static VariantModel dummy({
    String? type,
    String? value,
    double? additionalPrice,
  }) {
    final typeStr = (type ?? 'size').toLowerCase();
    final valueStr = value ?? 'M';
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Unique ID with random component
    final uniqueId =
        'var_${typeStr}_${valueStr}_${timestamp}_${random.nextInt(9999)}';

    return VariantModel(
      id: uniqueId,
      name: '${typeStr[0].toUpperCase()}${typeStr.substring(1)} - $valueStr',
      type: typeStr,
      value: valueStr,
      additionalPrice: additionalPrice,
      stock: random.nextInt(50) + 10,
      sku: 'SKU-$uniqueId',
      imageUrl: null,
      isActive: true,
    );
  }
}
