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
    );

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
      'vehicle_number': instance.vehicle,
      'customer_name': instance.name,
      'location': instance.location,
      'phone': instance.phone,
      'status': _$JobStatusEnumMap[instance.status]!,
    };

const _$JobStatusEnumMap = {
  JobStatus.pending: 'pending',
  JobStatus.completed: 'completed',
  JobStatus.cna: 'cna',
};
