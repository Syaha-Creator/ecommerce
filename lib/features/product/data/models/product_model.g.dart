// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toInt(),
      category:
          CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      brand: json['brand'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      isActive: json['isActive'] as bool,
      isFeatured: json['isFeatured'] as bool,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'images': instance.images,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'discountPercentage': instance.discountPercentage,
      'category': instance.category.toJson(),
      'brand': instance.brand,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'stock': instance.stock,
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'variants': instance.variants?.map((e) => e.toJson()).toList(),
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
