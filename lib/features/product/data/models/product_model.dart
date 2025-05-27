import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';
import 'category_model.dart';
import 'variant_model.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final double? discountPrice;
  final int? discountPercentage;
  final CategoryModel category;
  final String? brand;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isActive;
  final bool isFeatured;
  final List<VariantModel>? variants;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    this.discountPrice,
    this.discountPercentage,
    required this.category,
    this.brand,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.isActive,
    required this.isFeatured,
    this.variants,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  // Add finalPrice getter
  double get finalPrice => discountPrice ?? price;

  // Add hasDiscount getter
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  // Convert to entity
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: images,
      price: price,
      discountPrice: discountPrice,
      discountPercentage: discountPercentage,
      category: category.toEntity(),
      brand: brand,
      rating: rating,
      reviewCount: reviewCount,
      stock: stock,
      isActive: isActive,
      isFeatured: isFeatured,
      variants: variants?.map((v) => v.toEntity()).toList(),
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from entity
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      images: product.images,
      price: product.price,
      discountPrice: product.discountPrice,
      discountPercentage: product.discountPercentage,
      category: CategoryModel.fromEntity(product.category),
      brand: product.brand,
      rating: product.rating,
      reviewCount: product.reviewCount,
      stock: product.stock,
      isActive: product.isActive,
      isFeatured: product.isFeatured,
      variants:
          product.variants?.map((v) => VariantModel.fromEntity(v)).toList(),
      tags: product.tags,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }

  // Rest of the code remains the same...
  static ProductModel dummy({
    String? id,
    String? name,
    String? categoryId,
    double? price,
  }) {
    final now = DateTime.now();
    return ProductModel(
      id: id ?? 'prod_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Sample Product',
      description: 'This is a sample product description for testing purposes.',
      images: const [
        'https://via.placeholder.com/300x300',
        'https://via.placeholder.com/300x300',
      ],
      price: price ?? 99999,
      discountPrice: null,
      discountPercentage: null,
      category: CategoryModel.dummy(id: categoryId),
      brand: 'Sample Brand',
      rating: 4.5,
      reviewCount: 120,
      stock: 50,
      isActive: true,
      isFeatured: false,
      variants: null,
      tags: const ['new', 'popular'],
      createdAt: now,
      updatedAt: now,
    );
  }
}
