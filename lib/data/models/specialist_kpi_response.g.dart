// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist_kpi_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialistKpiResponse _$SpecialistKpiResponseFromJson(
        Map<String, dynamic> json) =>
    SpecialistKpiResponse(
      success: json['success'] as bool,
      data: SpecialistKpiData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$SpecialistKpiResponseToJson(
        SpecialistKpiResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.toJson(),
      'timestamp': instance.timestamp,
    };

SpecialistKpiData _$SpecialistKpiDataFromJson(Map<String, dynamic> json) =>
    SpecialistKpiData(
      totalJobs: (json['totalJobs'] as num).toInt(),
      completedThisWeek: (json['completedThisWeek'] as num).toInt(),
      reworkPercent: json['reworkPercent'] as num,
      averageRating: json['averageRating'] as num,
    );

Map<String, dynamic> _$SpecialistKpiDataToJson(SpecialistKpiData instance) =>
    <String, dynamic>{
      'totalJobs': instance.totalJobs,
      'completedThisWeek': instance.completedThisWeek,
      'reworkPercent': instance.reworkPercent,
      'averageRating': instance.averageRating,
    };
