// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_services_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnServicesResponse _$AddOnServicesResponseFromJson(
        Map<String, dynamic> json) =>
    AddOnServicesResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => AddOnService.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$AddOnServicesResponseToJson(
        AddOnServicesResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };
