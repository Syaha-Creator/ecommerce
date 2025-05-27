import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/variant.dart';

part 'variant_model.g.dart';

@JsonSerializable()
class VariantModel extends Variant {
  const VariantModel({
    required String id,
    required String name,
    required String type,
    required String value,
    double? additionalPrice,
    required int stock,
    String? sku,
    String? imageUrl,
    required bool isActive,
  }) : super(
          id: id,
          name: name,
          type: type,
          value: value,
          additionalPrice: additionalPrice,
          stock: stock,
          sku: sku,
          imageUrl: imageUrl,
          isActive: isActive,
        );

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);

  Map<String, dynamic> toJson() => _$VariantModelToJson(this);

  // Add toEntity method
  Variant toEntity() {
    return Variant(
      id: id,
      name: name,
      type: type,
      value: value,
      additionalPrice: additionalPrice,
      stock: stock,
      sku: sku,
      imageUrl: imageUrl,
      isActive: isActive,
    );
  }

  factory VariantModel.fromEntity(Variant variant) {
    return VariantModel(
      id: variant.id,
      name: variant.name,
      type: variant.type,
      value: variant.value,
      additionalPrice: variant.additionalPrice,
      stock: variant.stock,
      sku: variant.sku,
      imageUrl: variant.imageUrl,
      isActive: variant.isActive,
    );
  }

  static VariantModel dummy({
    String? type,
    String? value,
    double? additionalPrice,
  }) {
    return VariantModel(
      id: 'var_${DateTime.now().millisecondsSinceEpoch}',
      name: '${type ?? "Size"} - ${value ?? "M"}',
      type: type ?? 'size',
      value: value ?? 'M',
      additionalPrice: additionalPrice,
      stock: 20,
      sku: 'SKU-${DateTime.now().millisecondsSinceEpoch}',
      imageUrl: null,
      isActive: true,
    );
  }
}
