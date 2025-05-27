// lib/features/product/domain/entities/product.dart
import 'package:equatable/equatable.dart';
import 'variant.dart';
import 'category.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final double? discountPrice;
  final int? discountPercentage;
  final Category category;
  final String? brand;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isActive;
  final bool isFeatured;
  final List<Variant>? variants;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
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

  // Calculate final price considering discount
  double get finalPrice => discountPrice ?? price;

  // Check if product has discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  // Check if product is in stock
  bool get inStock => stock > 0;

  // Get main image
  String get mainImage => images.isNotEmpty ? images.first : '';

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        price,
        discountPrice,
        discountPercentage,
        category,
        brand,
        rating,
        reviewCount,
        stock,
        isActive,
        isFeatured,
        variants,
        tags,
        createdAt,
        updatedAt,
      ];
}
