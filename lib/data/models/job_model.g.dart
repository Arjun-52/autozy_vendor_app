// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
      vehicle: json['vehicle_number'] as String,
      name: json['customer_name'] as String,
      location: json['location'] as String,
      phone: json['phone'] as String,
      status: $enumDecodeNullable(_$JobStatusEnumMap, json['status']) ??
          JobStatus.pending,
      beforeImage: json['before_image'] as String?,
      capturedAt: json['captured_at'] as String?,
    );

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
      'vehicle_number': instance.vehicle,
      'customer_name': instance.name,
      'location': instance.location,
      'phone': instance.phone,
      'status': _$JobStatusEnumMap[instance.status]!,
      'before_image': instance.beforeImage,
      'captured_at': instance.capturedAt,
    };

const _$JobStatusEnumMap = {
  JobStatus.pending: 'pending',
  JobStatus.cleaning: 'cleaning',
  JobStatus.completed: 'completed',
  JobStatus.cna: 'cna',
};
