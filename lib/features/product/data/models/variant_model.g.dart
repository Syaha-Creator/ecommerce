// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VariantModel _$VariantModelFromJson(Map<String, dynamic> json) => VariantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      value: json['value'] as String,
      additionalPrice: (json['additionalPrice'] as num?)?.toDouble(),
      stock: (json['stock'] as num).toInt(),
      sku: json['sku'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$VariantModelToJson(VariantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
      'additionalPrice': instance.additionalPrice,
      'stock': instance.stock,
      'sku': instance.sku,
      'imageUrl': instance.imageUrl,
      'isActive': instance.isActive,
    };
