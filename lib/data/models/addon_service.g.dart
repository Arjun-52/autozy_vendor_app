// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnService _$AddOnServiceFromJson(Map<String, dynamic> json) => AddOnService(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      price: json['price'] as String,
      pricingId: json['pricingId'] as String,
    );

Map<String, dynamic> _$AddOnServiceToJson(AddOnService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'estimatedDuration': instance.estimatedDuration,
      'price': instance.price,
      'pricingId': instance.pricingId,
    };
