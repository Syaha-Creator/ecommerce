// lib/features/product/domain/entities/category.dart
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? parentId;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.parentId,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if this is a root category
  bool get isRootCategory => parentId == null;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        parentId,
        order,
        isActive,
        createdAt,
        updatedAt,
      ];
}
