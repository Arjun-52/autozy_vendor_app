// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist_jobs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialistJobsResponse _$SpecialistJobsResponseFromJson(
        Map<String, dynamic> json) =>
    SpecialistJobsResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => SpecialistJobModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$SpecialistJobsResponseToJson(
        SpecialistJobsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };
