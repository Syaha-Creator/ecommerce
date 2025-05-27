// lib/features/product/domain/entities/variant.dart
import 'package:equatable/equatable.dart';

class Variant extends Equatable {
  final String id;
  final String name;
  final String type; // e.g., "color", "size", "storage"
  final String value; // e.g., "red", "XL", "128GB"
  final double? additionalPrice;
  final int stock;
  final String? sku;
  final String? imageUrl;
  final bool isActive;

  const Variant({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    this.additionalPrice,
    required this.stock,
    this.sku,
    this.imageUrl,
    required this.isActive,
  });

  // Check if variant is in stock
  bool get inStock => stock > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        value,
        additionalPrice,
        stock,
        sku,
        imageUrl,
        isActive,
      ];
  @override
  String toString() => 'Variant($id, $type, $value)';
}
