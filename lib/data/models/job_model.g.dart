// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobRemarkModel _$JobRemarkModelFromJson(Map<String, dynamic> json) =>
    JobRemarkModel(
      reason: json['reason'] as String,
      additionalComment: json['additional_comment'] as String?,
      createdBy: json['created_by'] as String? ?? 'Detailer Mode',
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$JobRemarkModelToJson(JobRemarkModel instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'additional_comment': instance.additionalComment,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt,
    };

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
      vehicle: json['vehicle_number'] as String,
      name: json['customer_name'] as String,
      location: json['location'] as String,
      phone: json['phone'] as String,
      status: $enumDecodeNullable(_$JobStatusEnumMap, json['status']) ??
          JobStatus.pending,
      beforeImage: json['before_image'] as String?,
      capturedAt: json['captured_at'] as String?,
      afterImage: json['after_image'] as String?,
      afterImageCapturedAt: json['after_captured_at'] as String?,
      remarks: (json['remarks'] as List<dynamic>?)
          ?.map((e) => JobRemarkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
      'vehicle_number': instance.vehicle,
      'customer_name': instance.name,
      'location': instance.location,
      'phone': instance.phone,
      'status': _$JobStatusEnumMap[instance.status]!,
      'before_image': instance.beforeImage,
      'captured_at': instance.capturedAt,
      'after_image': instance.afterImage,
      'after_captured_at': instance.afterImageCapturedAt,
      'remarks': instance.remarks,
    };

const _$JobStatusEnumMap = {
  JobStatus.pending: 'pending',
  JobStatus.cleaning: 'cleaning',
  JobStatus.completed: 'completed',
  JobStatus.cna: 'cna',
};
