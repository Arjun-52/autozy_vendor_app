// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_subscription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionSubscriptionResponse _$InspectionSubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    InspectionSubscriptionResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : InspectionModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$InspectionSubscriptionResponseToJson(
        InspectionSubscriptionResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };
