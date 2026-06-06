// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_queue_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionQueueResponse _$InspectionQueueResponseFromJson(
        Map<String, dynamic> json) =>
    InspectionQueueResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => InspectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InspectionQueueResponseToJson(
        InspectionQueueResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
