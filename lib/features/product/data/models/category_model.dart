import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Category {
  const CategoryModel({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
    String? parentId,
    required int order,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          name: name,
          description: description,
          imageUrl: imageUrl,
          parentId: parentId,
          order: order,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  // Add toEntity method
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      parentId: parentId,
      order: order,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      imageUrl: category.imageUrl,
      parentId: category.parentId,
      order: category.order,
      isActive: category.isActive,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  // Rest of the code remains the same...
  static CategoryModel dummy({String? id, String? name}) {
    final now = DateTime.now();
    return CategoryModel(
      id: id ?? 'cat_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Electronics',
      description: 'Electronic devices and accessories',
      imageUrl: 'https://via.placeholder.com/150x150',
      parentId: null,
      order: 1,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  static List<CategoryModel> dummyCategories() {
    final now = DateTime.now();
    return [
      CategoryModel(
        id: 'cat_electronics',
        name: 'Electronics',
        description: 'Electronic devices and accessories',
        imageUrl: 'https://via.placeholder.com/150x150',
        parentId: null,
        order: 1,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'cat_fashion',
        name: 'Fashion',
        description: 'Clothing and fashion accessories',
        imageUrl: 'https://via.placeholder.com/150x150',
        parentId: null,
        order: 2,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'cat_home',
        name: 'Home & Living',
        description: 'Furniture and home decor',
        imageUrl: 'https://via.placeholder.com/150x150',
        parentId: null,
        order: 3,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'cat_beauty',
        name: 'Beauty & Health',
        description: 'Beauty and health products',
        imageUrl: 'https://via.placeholder.com/150x150',
        parentId: null,
        order: 4,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'cat_sports',
        name: 'Sports & Outdoor',
        description: 'Sports equipment and outdoor gear',
        imageUrl: 'https://via.placeholder.com/150x150',
        parentId: null,
        order: 5,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'cat_food',
        name: 'Food & Drinks',
        description: 'Food and beverage products',
        imageUrl: 'https://via.placeholder.com/150x150',
        parentId: null,
        order: 6,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'cat_books',
        name: 'Books',
        description: 'Books and literature',
        imageUrl: 'https://via.placeholder.com/150x150',
        parentId: null,
        order: 7,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryModel(
        id: 'cat_toys',
        name: 'Toys',
        description: 'Toys and games',
        imageUrl: 'https://via.placeholder.com/150x150',
        parentId: null,
        order: 8,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
