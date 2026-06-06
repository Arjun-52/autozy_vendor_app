// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_service_records_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminServiceRecordsResponse _$AdminServiceRecordsResponseFromJson(
        Map<String, dynamic> json) =>
    AdminServiceRecordsResponse(
      success: json['success'] as bool,
      data: json['data'] as List<dynamic>,
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$AdminServiceRecordsResponseToJson(
        AdminServiceRecordsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'meta': instance.meta,
      'timestamp': instance.timestamp,
    };
