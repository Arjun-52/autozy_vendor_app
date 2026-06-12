// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wash_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WashHistoryRecord _$WashHistoryRecordFromJson(Map<String, dynamic> json) =>
    WashHistoryRecord(
      vehicle: json['vehicle_number'] as String?,
      status: json['status'] as String?,
      completedAt: json['completed_at'] as String?,
      cnaStatus: json['cna_status'] as String?,
      serviceDate: json['service_date'] as String?,
    );

Map<String, dynamic> _$WashHistoryRecordToJson(WashHistoryRecord instance) =>
    <String, dynamic>{
      'vehicle_number': instance.vehicle,
      'status': instance.status,
      'completed_at': instance.completedAt,
      'cna_status': instance.cnaStatus,
      'service_date': instance.serviceDate,
    };

WashHistoryResponse _$WashHistoryResponseFromJson(Map<String, dynamic> json) =>
    WashHistoryResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => WashHistoryRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$WashHistoryResponseToJson(
        WashHistoryResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'meta': instance.meta,
      'timestamp': instance.timestamp,
    };
